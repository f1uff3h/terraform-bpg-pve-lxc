variable "pve_node" {
  type        = string
  description = "The Proxmox VE node on which to create the container."
}

variable "lxc_template" {
  type        = string
  description = "The LXC template to use for the container."
}
