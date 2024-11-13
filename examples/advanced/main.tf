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

module "ct_advanced" {
  source = "../../"

  ct_node         = "mypvenode"
  ct_id           = 99999
  ct_unprivileged = false
  ct_pool         = "mypool"
  ct_protection   = true

  ct_start = {
    on_deploy  = true
    on_boot    = false
    order      = 1
    up_delay   = 10
    down_delay = 10
  }

  ct_cpu = {
    arch  = "amd64"
    cores = 2
  }
  ct_mem = {
    dedicated = 1024
    swap      = 0
  }
  ct_disk = {
    datastore = "local"
    size      = 25
  }
  ct_net_ifaces = {
    eth0 = {
      name      = "eth0"
      bridge    = "vmbr0"
      enabled   = true
      firewall  = true
      ipv4_addr = "dhcp"
    }
  }
  ct_fw = {
    enabled = true
  }
  ct_fw_rules = {
    HTTP = {
      enabled   = true
      direction = "in"
      action    = "ACCEPT"
      dport     = "80"
      proto     = "tcp"
      log       = "info"
      comment   = "Allow HTTP traffic"
    }
  }
  ct_fw_fsg = {
    ldapserver = {
      enabled = true
    }
  }
  ct_os_upload = {
    datastore = "local"
    source    = "https://jenkins.linuxcontainers.org/view/Images/job/image-alpine/architecture=amd64,release=3.19,variant=default/lastSuccessfulBuild/artifact/rootfs.tar.xz"
    file_name = "mycontainer.tar.xz"
  }
  ct_init = {
    hostname = "ct_advanced"
    root_keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDOirOqj4+ezShbUrdgk0hB6qP8EKAWszd6ATG3xUqM8o+utpidxOqBEw4C1Z3o9o6aHC66T4bTGTz4Ba9shT6HazxMwc4BM7fZZDqx+92dH+osbyrHgn4ihR//Lwc1SlWtU/T9f+S3IFBRAfWMeN+jMrXI0cM7BM01Buu8GDOUg9KcwxraHH5wZvILZ9GgBnaEhyHj3LIo6Yj6aeTDAe4SjMssxwbz3LL/fIeEtT+0z3YxhDYhVujKmeGS/eSIrEHmX22keBaUPbFNIGB9ze7EVT9q54A9Gor9yTmw+7LaGfY6oNBXfSQQ6lwAYONjxeUDLQug9hybjXqCRpiZNLJXPF+40BFy7SCRRTvimKCLC+Uy4goT478zLbWM6wtBIj88nBZXu2nkl3HRMjiKd/IQwGb1b2hZIcRvPU+CKV23eyFW1sXxza6x12xmcsiCE6PltEc6CePymZuapTWe6LAPmHnksTHloPILjMiGaVPIlmS4fxznQqkpg5DqfJAn900= root@676521e00bc6",
    ]
  }

  ct_tags = [
    "super",
    "useful",
    "tags",
  ]
}
