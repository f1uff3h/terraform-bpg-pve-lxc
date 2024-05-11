terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~>0"
    }
  }
}

provider "proxmox" {
  insecure = true
}

module "ct_basic" {
  source = "../../"

  ct-node = "my-pve-node"
  ct-id   = 9999
  ct-os   = "store:vztmpl/lxc-template.txz"
}
