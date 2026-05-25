module "lxc" {
  source = "git::https://github.com/andrewzn69/tf-proxmox-lxc.git"

  hostname              = var.hostname
  node_name             = var.node_name
  vm_id                 = var.vm_id
  template_datastore_id = var.template_datastore_id
  template_url          = var.template_url
  os_type               = "debian"
  unprivileged          = true
  ip_address            = var.ip_address
  gateway_ip            = var.gateway_ip
  datastore_id          = var.datastore_id
  disk_size             = var.disk_size
  ssh_keys              = var.ssh_keys
}

resource "ansible_host" "netboot" {
  name   = module.lxc.ipv4_address
  groups = ["netboot"]
}

resource "ansible_playbook" "netboot" {
  name       = ansible_host.netboot.name
  playbook   = "${path.module}/playbook.yaml"
  replayable = true

  depends_on = [module.lxc]
}
