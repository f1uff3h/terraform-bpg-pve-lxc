module "ct_advanced" {
  source = "../../"

  ct-node         = var.pve_node
  ct-id           = 9999
  ct-unprivileged = false
  ct-pool         = "dev"

  ct-start = {
    on-deploy  = true
    on-boot    = false
    order      = 1
    up-delay   = 10
    down-delay = 10
  }

  ct-cpu = {
    arch  = "amd64"
    cores = 2
  }
  ct-mem = {
    dedicated = 1024
    swap      = 0
  }
  ct-disk = {
    datastore = "local"
    size      = 25
  }
  ct-net-ifaces = {
    eth0 = {
      name      = "eth0"
      bridge    = "vmbr0"
      enabled   = true
      firewall  = true
      ipv4_addr = "dhcp"
    }
  }
  ct-fw = {
    options = {
      enabled = true
    }
    rules = {
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
  }
  ct-os-upload = {
    datastore = "iso"
    source    = "https://jenkins.linuxcontainers.org/view/Images/job/image-debian/architecture=amd64,release=bookworm,variant=default/lastSuccessfulBuild/artifact/rootfs.tar.xz"
    file_name = "debian-bookworm-amd64-20240507.tar.xz"
  }
  ct-init = {
    hostname = "ct-advanced"
    root_keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDOirOqj4+ezShbUrdgk0hB6qP8EKAWszd6ATG3xUqM8o+utpidxOqBEw4C1Z3o9o6aHC66T4bTGTz4Ba9shT6HazxMwc4BM7fZZDqx+92dH+osbyrHgn4ihR//Lwc1SlWtU/T9f+S3IFBRAfWMeN+jMrXI0cM7BM01Buu8GDOUg9KcwxraHH5wZvILZ9GgBnaEhyHj3LIo6Yj6aeTDAe4SjMssxwbz3LL/fIeEtT+0z3YxhDYhVujKmeGS/eSIrEHmX22keBaUPbFNIGB9ze7EVT9q54A9Gor9yTmw+7LaGfY6oNBXfSQQ6lwAYONjxeUDLQug9hybjXqCRpiZNLJXPF+40BFy7SCRRTvimKCLC+Uy4goT478zLbWM6wtBIj88nBZXu2nkl3HRMjiKd/IQwGb1b2hZIcRvPU+CKV23eyFW1sXxza6x12xmcsiCE6PltEc6CePymZuapTWe6LAPmHnksTHloPILjMiGaVPIlmS4fxznQqkpg5DqfJAn900= root@676521e00bc6",
    ]
  }

  ct-tags = [
    "super",
    "useful",
    "tags",
  ]
}
