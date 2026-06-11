resource "tailscale_tailnet_key" "node" {
  description   = "novigrad novigrad-node registration" # needs to be hardcoded because acl in tailscale
  ephemeral     = false
  expiry        = 2000
  preauthorized = true
  reusable      = true
  tags          = ["tag:novigrad-node"]
}

module "oke" {
  source = "git::https://github.com/andrewzn69/tf-oci-free-oke.git?ref=v0.1.9"

  compartment_id           = var.compartment_id
  name                     = var.name
  kubernetes_version       = var.kubernetes_version
  control_plane_type       = "private"
  install_flannel          = false
  create_bastion           = false
  node_count               = var.node_count
  node_ocpus               = var.node_ocpus
  node_memory_gb           = var.node_memory_gb
  node_boot_volume_size_gb = var.node_boot_volume_size_gb
  node_data_volume_size_gb = var.node_data_volume_size_gb
  pods_cidr                = var.pods_cidr
  services_cidr            = var.services_cidr
  ssh_public_key           = var.ssh_public_key
  cloud_init_local = templatefile("${path.module}/cloud-init.sh", {
    auth_key             = tailscale_tailnet_key.node.key
    endpoint_subnet_cidr = "10.0.0.0/24"
  })

  extra_nodes_ingress_rules = [
    for port in var.exposed_ports : {
      source      = "0.0.0.0/0"
      protocol    = port.protocol
      tcp_options = port.protocol == "6" ? { min = port.min, max = port.max } : null
      udp_options = port.protocol == "17" ? { min = port.min, max = port.max } : null
    }
  ]
}

resource "oci_core_route_table" "lb" {
  compartment_id = var.compartment_id
  vcn_id         = module.oke.vcn_id
  display_name   = "${var.name}-lb-rt"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = module.oke.internet_gateway_id
  }
}

resource "oci_core_security_list" "lb" {
  compartment_id = var.compartment_id
  vcn_id         = module.oke.vcn_id
  display_name   = "${var.name}-lb-sl"

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
    stateless   = false
  }

  dynamic "ingress_security_rules" {
    for_each = var.lb_exposed_ports
    content {
      source    = "0.0.0.0/0"
      protocol  = ingress_security_rules.value.protocol
      stateless = false

      dynamic "tcp_options" {
        for_each = ingress_security_rules.value.protocol == "6" ? [ingress_security_rules.value] : []
        content {
          min = tcp_options.value.min
          max = tcp_options.value.max
        }
      }

      dynamic "udp_options" {
        for_each = ingress_security_rules.value.protocol == "17" ? [ingress_security_rules.value] : []
        content {
          min = udp_options.value.min
          max = udp_options.value.max
        }
      }
    }
  }
}

resource "oci_core_subnet" "lb" {
  compartment_id             = var.compartment_id
  vcn_id                     = module.oke.vcn_id
  display_name               = "${var.name}-lb-subnet"
  cidr_block                 = var.lb_subnet_cidr_block
  route_table_id             = oci_core_route_table.lb.id
  security_list_ids          = [oci_core_security_list.lb.id]
  dns_label                  = "lb"
  prohibit_public_ip_on_vnic = false
}

resource "terraform_data" "wait_for_oke_endpoint" {
  triggers_replace = module.oke.cluster_id

  depends_on = [module.oke]

  provisioner "local-exec" {
    command = <<-EOT
      for i in $(seq 1 60); do
        curl -sk --max-time 3 "https://${module.oke.cluster_endpoint}/version" && exit 0
        sleep 5
      done
      echo "timed out waiting for OKE API endpoint" >&2
      exit 1
    EOT
  }
}

module "cilium" {
  source = "git::https://github.com/andrewzn69/tf-cilium.git?ref=v0.1.4"

  cilium_version   = var.cilium_version
  values_default   = "oke"
  cluster_endpoint = "https://${module.oke.cluster_endpoint}"

  depends_on = [module.oke, terraform_data.wait_for_oke_endpoint]
}
