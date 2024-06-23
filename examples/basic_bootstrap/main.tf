terraform {
  required_version = "~>1.4"

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~>0"
    }
    time = {
      source  = "hashicorp/time"
      version = "~>0"
    }
  }
}

module "ct_basic_bootstrap" {
  source = "../../"

  ct-node = "mynode"
  ct-os   = "mystore:vztmpl/mytemplate"
  # ct-os-type = "myostype"
  ct-net-ifaces = {
    eth0 = {
      name      = "eth0"
      ipv4_addr = "192.168.1.10/24"
      ipv4_gw   = "192.168.1.0"
    }
  }
  # ct-init = {
  #   root_keys = [
  #     file("path/to/ssh/pubkey")
  #   ]
  # }
  ct-ssh-privkey      = "path/to/ssh/privkey"
  ct-bootstrap-script = "./bootstrap.sh"
}
