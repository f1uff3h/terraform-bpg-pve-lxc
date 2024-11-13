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

  ct_node    = "mypvenode"
  ct_os      = "local:vztmpl/mylxctemplate"
  ct_os_type = "<insert-os-type>" # otherwise static IPs don't get set
  ct_net_ifaces = {
    eth0 = {
      name      = "eth0"
      ipv4_addr = "<insert-ip-here>/24"
      ipv4_gw   = "<insert-network-gateway-ip>"
    }
  }
  ct_init = {
    hostname = "test-vm"
    root_keys = [
      file("../../test_key.pub")
    ]
  }
  ct_ssh_privkey      = "../../test_key"
  ct_bootstrap_script = "./bootstrap.sh"
}
