locals {
  cluster_endpoint = "https://${cidrhost(var.node_subnet, var.control_plane_groups[0].ip_range_start)}:6443"
}
