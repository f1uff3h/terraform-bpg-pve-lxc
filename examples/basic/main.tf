terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~>0"
    }
  }
}

module "ct_basic" {
  source = "../../"

  ct_node = "mypvenode"
  ct_os   = "local:vztmpl/mylxctemplate"
  ct_net_ifaces = {
    eth0 = {
      name      = "eth0"
      ipv4_addr = "dhcp"
    }
  }
}
