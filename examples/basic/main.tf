module "ct_basic" {
  source = "../../"

  ct-node = var.pve_node
  ct-id   = 9999
  ct-os   = var.lxc_template
}
