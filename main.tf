terraform {
  required_version = ">= 1.4"
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.55"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0"
    }
  }
}

resource "random_password" "ct_root_pw" {
  count  = var.ct-init.root_pw == null ? 1 : 0
  length = 26
}

resource "proxmox_virtual_environment_download_file" "ct_template" {
  count = var.ct-os-upload.source == null ? 0 : 1

  content_type        = "vztmpl"
  node_name           = var.ct-node
  datastore_id        = var.ct-os-upload.datastore
  url                 = var.ct-os-upload.source
  file_name           = var.ct-os-upload.file_name
  overwrite           = var.ct-os-upload.overwrite
  overwrite_unmanaged = var.ct-os-upload.overwrite_unmanaged

  checksum                = var.ct-os-upload.checksum
  checksum_algorithm      = var.ct-os-upload.checksum_alg
  decompression_algorithm = var.ct-os-upload.decomp_alg

  upload_timeout = var.ct-os-upload.timeout
  verify         = var.ct-os-upload.verify

  lifecycle {
    precondition {
      condition     = var.ct-os == null
      error_message = "Variables 'ct-os' and 'ct-os-upload' are mutually exclusive!"
    }
  }
}

resource "proxmox_virtual_environment_container" "ct" {
  description   = "Managed by Terraform"
  node_name     = var.ct-node
  pool_id       = var.ct-pool
  started       = var.ct-start.on-deploy
  start_on_boot = var.ct-start.on-boot

  startup {
    order      = var.ct-start.order
    up_delay   = var.ct-start.up-delay
    down_delay = var.ct-start.down-delay
  }
  unprivileged = var.ct-unprivileged
  vm_id        = var.ct-id

  cpu {
    architecture = var.ct-cpu.arch
    cores        = var.ct-cpu.cores
    units        = var.ct-cpu.units
  }

  memory {
    dedicated = var.ct-mem.dedicated
    swap      = var.ct-mem.swap
  }

  disk {
    datastore_id = var.ct-disk.datastore
    size         = var.ct-disk.size
  }

  dynamic "network_interface" {
    for_each = var.ct-net-ifaces
    content {
      name        = network_interface.value.name
      bridge      = network_interface.value.bridge
      enabled     = network_interface.value.enabled
      firewall    = network_interface.value.firewall
      mac_address = network_interface.value.mac_address
      mtu         = network_interface.value.mtu
      rate_limit  = network_interface.value.rate_limit
      vlan_id     = network_interface.value.vlan_id
    }
  }

  dynamic "clone" {
    for_each = var.clone-target
    content {
      vm_id        = clone.value.vm_id
      node_name    = clone.value.node_name
      datastore_id = clone.value.datastore
    }
  }

  operating_system {
    template_file_id = var.ct-os != null ? var.ct-os : proxmox_virtual_environment_download_file.ct_template[0].id
    type             = var.ct-os-type
  }

  console {
    enabled   = var.ct-console.enabled
    type      = var.ct-console.type
    tty_count = var.ct-console.tty_count
  }

  initialization {
    hostname = var.ct-init.hostname
    dynamic "dns" {
      for_each = var.ct-dns != null ? [1] : []

      content {
        domain  = var.ct-dns.domain
        servers = var.ct-dns.servers
      }
    }
    dynamic "ip_config" {
      for_each = var.ct-net-ifaces
      content {
        ipv4 {
          address = ip_config.value.ipv4_addr
          gateway = ip_config.value.ipv4_gw
        }
        ipv6 {
          address = ip_config.value.ipv6_addr
          gateway = ip_config.value.ipv6_gw
        }
      }
    }
    user_account {
      password = var.ct-init.root_pw != null ? var.ct-init.root_pw : random_password.ct_root_pw[0].result
      keys     = var.ct-init.root_keys
    }
  }

  dynamic "features" {
    for_each = var.ct-features != null ? [1] : []

    content {
      nesting = try(var.ct-features.nesting, true)
      fuse    = var.ct-features.fuse
      keyctl  = var.ct-features.keyctl
      mount   = var.ct-features.mount
    }
  }

  template = var.ct-template
  tags     = var.ct-tags

  lifecycle {
    precondition {
      condition     = (var.ct-os == null && var.ct-os-upload.source != null) || (var.ct-os-upload.source == null && var.ct-os != null)
      error_message = "Variables 'ct-os' and 'ct-os-upload' are mutually exclusive!"
    }
  }
}

resource "proxmox_virtual_environment_firewall_options" "ct_fw_opts" {
  count = length(var.ct-fw) > 0 ? 0 : 1

  node_name    = proxmox_virtual_environment_container.ct.node_name
  container_id = proxmox_virtual_environment_container.ct.vm_id

  enabled       = var.ct-fw.enabled
  dhcp          = var.ct-fw.dhcp
  input_policy  = var.ct-fw.input_policy
  output_policy = var.ct-fw.output_policy
  log_level_in  = try(var.ct-fw.log_level_in, "nolog")
  log_level_out = try(var.ct-fw.log_level_out, "nolog")
  macfilter     = var.ct-fw.macfilter
  ipfilter      = var.ct-fw.ipfilter
  ndp           = var.ct-fw.ndp
  radv          = var.ct-fw.radv
}

resource "proxmox_virtual_environment_firewall_rules" "ct_fw_rules" {
  count = length(var.ct-fw-rules) > 0 || length(var.ct-fw-fsg) > 0 ? 1 : 0

  node_name    = proxmox_virtual_environment_container.ct.node_name
  container_id = proxmox_virtual_environment_container.ct.vm_id

  dynamic "rule" {
    for_each = var.ct-fw-rules

    content {
      enabled = rule.value.enabled
      action  = rule.value.action
      type    = rule.value.direction
      source  = rule.value.sourceip
      dest    = rule.value.destip
      sport   = rule.value.sport
      dport   = rule.value.dport
      proto   = rule.value.proto
      log     = rule.value.log
      comment = "${rule.value.comment == null ? "" : rule.value.comment}; Managed by Terraform"
    }
  }

  dynamic "rule" {
    for_each = var.ct-fw-fsg

    content {
      enabled        = rule.value.enabled
      security_group = rule.key
      iface          = rule.value.iface
      comment        = "${rule.value.comment == null ? "" : rule.value.comment}; Managed by Terraform"
    }
  }
}

resource "time_sleep" "wait_for_ct" {
  count           = var.ct-bootstrap-script == null ? 0 : 1
  create_duration = "10s"
  triggers = {
    vmid = proxmox_virtual_environment_container.ct.vm_id
  }
  depends_on = [
    proxmox_virtual_environment_container.ct
  ]
}

resource "terraform_data" "bootstrap_ct" {
  count = var.ct-bootstrap-script == null ? 0 : 1

  connection {
    type        = "ssh"
    host        = replace(proxmox_virtual_environment_container.ct.initialization[0].ip_config[0].ipv4[0].address, "/24", "")
    user        = "root"
    private_key = file(var.ct-ssh-privkey)
  }
  provisioner "remote-exec" {
    script = var.ct-bootstrap-script
  }

  triggers_replace = [
    time_sleep.wait_for_ct[0].id
  ]

  depends_on = [
    time_sleep.wait_for_ct
  ]
}
