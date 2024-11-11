terraform {
  required_version = ">= 1.4"
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.66"
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
  count  = var.ct_init.root_pw == null ? 1 : 0
  length = 26
}

resource "proxmox_virtual_environment_download_file" "ct_template" {
  count = var.ct_os_upload.source == null ? 0 : 1

  content_type        = "vztmpl"
  node_name           = var.ct_node
  datastore_id        = var.ct_os_upload.datastore
  url                 = var.ct_os_upload.source
  file_name           = var.ct_os_upload.file_name
  overwrite           = var.ct_os_upload.overwrite
  overwrite_unmanaged = var.ct_os_upload.overwrite_unmanaged

  checksum                = var.ct_os_upload.checksum
  checksum_algorithm      = var.ct_os_upload.checksum_alg
  decompression_algorithm = var.ct_os_upload.decomp_alg

  upload_timeout = var.ct_os_upload.timeout
  verify         = var.ct_os_upload.verify

  lifecycle {
    precondition {
      condition     = var.ct_os == null
      error_message = "Variables 'ct_os' and 'ct_os_upload' are mutually exclusive!"
    }
  }
}

resource "proxmox_virtual_environment_container" "ct" {
  description   = "Managed by Terraform"
  node_name     = var.ct_node
  pool_id       = var.ct_pool
  started       = var.ct_start.on-deploy
  start_on_boot = var.ct_start.on-boot
  protection    = var.ct_protection

  startup {
    order      = var.ct_start.order
    up_delay   = var.ct_start.up-delay
    down_delay = var.ct_start.down-delay
  }
  unprivileged = var.ct_unprivileged
  vm_id        = var.ct_id

  cpu {
    architecture = var.ct_cpu.arch
    cores        = var.ct_cpu.cores
    units        = var.ct_cpu.units
  }

  memory {
    dedicated = var.ct_mem.dedicated
    swap      = var.ct_mem.swap
  }

  disk {
    datastore_id = var.ct_disk.datastore
    size         = var.ct_disk.size
  }

  dynamic "network_interface" {
    for_each = var.ct_net_ifaces
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
    for_each = var.clone_target
    content {
      vm_id        = clone.value.vm_id
      node_name    = clone.value.node_name
      datastore_id = clone.value.datastore
    }
  }

  operating_system {
    template_file_id = var.ct_os != null ? var.ct_os : proxmox_virtual_environment_download_file.ct_template[0].id
    type             = var.ct_os-type
  }

  console {
    enabled   = var.ct_console.enabled
    type      = var.ct_console.type
    tty_count = var.ct_console.tty_count
  }

  initialization {
    hostname = var.ct_init.hostname
    dynamic "dns" {
      for_each = var.ct_dns != null ? [1] : []

      content {
        domain  = var.ct_dns.domain
        servers = var.ct_dns.servers
      }
    }
    dynamic "ip_config" {
      for_each = var.ct_net-ifaces
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
      password = var.ct_init.root_pw != null ? var.ct_init.root_pw : random_password.ct_root_pw[0].result
      keys     = var.ct_init.root_keys
    }
  }

  dynamic "features" {
    for_each = var.ct_features != null ? [1] : []

    content {
      nesting = try(var.ct_features.nesting, true)
      fuse    = var.ct_features.fuse
      keyctl  = var.ct_features.keyctl
      mount   = var.ct_features.mount
    }
  }

  template = var.ct_template
  tags     = var.ct_tags

  lifecycle {
    precondition {
      condition     = (var.ct_os == null && var.ct_os_upload.source != null) || (var.ct_os_upload.source == null && var.ct_os != null)
      error_message = "Variables 'ct_os' and 'ct_os_upload' are mutually exclusive!"
    }
  }
}

resource "proxmox_virtual_environment_firewall_options" "ct_fw_opts" {
  count = length(var.ct_fw) > 0 ? 1 : 0

  node_name    = proxmox_virtual_environment_container.ct.node_name
  container_id = proxmox_virtual_environment_container.ct.vm_id

  enabled       = var.ct_fw.enabled
  dhcp          = var.ct_fw.dhcp
  input_policy  = var.ct_fw.input_policy
  output_policy = var.ct_fw.output_policy
  log_level_in  = try(var.ct_fw.log_level_in, "nolog")
  log_level_out = try(var.ct_fw.log_level_out, "nolog")
  macfilter     = var.ct_fw.macfilter
  ipfilter      = var.ct_fw.ipfilter
  ndp           = var.ct_fw.ndp
  radv          = var.ct_fw.radv
}

resource "proxmox_virtual_environment_firewall_rules" "ct_fw_rules" {
  count = length(var.ct_fw_rules) > 0 || length(var.ct_fw_fsg) > 0 ? 1 : 0

  node_name    = proxmox_virtual_environment_container.ct.node_name
  container_id = proxmox_virtual_environment_container.ct.vm_id

  dynamic "rule" {
    for_each = var.ct_fw_rules

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
    for_each = var.ct_fw_fsg

    content {
      enabled        = rule.value.enabled
      security_group = rule.key
      iface          = rule.value.iface
      comment        = "${rule.value.comment == null ? "" : rule.value.comment}; Managed by Terraform"
    }
  }
}

resource "time_sleep" "wait_for_ct" {
  count           = var.ct_bootstrap_script == null ? 0 : 1
  create_duration = "10s"
  triggers = {
    vmid = proxmox_virtual_environment_container.ct.vm_id
  }
  depends_on = [
    proxmox_virtual_environment_container.ct
  ]
}

resource "terraform_data" "bootstrap_ct" {
  count = var.ct_bootstrap_script == null ? 0 : 1

  connection {
    type        = "ssh"
    host        = replace(proxmox_virtual_environment_container.ct.initialization[0].ip_config[0].ipv4[0].address, "/24", "")
    user        = "root"
    private_key = file(var.ct_ssh_privkey)
  }
  provisioner "remote-exec" {
    script = var.ct_bootstrap_script
  }

  triggers_replace = [
    time_sleep.wait_for_ct[0].id
  ]

  depends_on = [
    time_sleep.wait_for_ct
  ]

  lifecycle {
    precondition {
      condition     = var.ct_ssh_privkey != null
      error_message = "Bootstrap script cannot be executed without ssh private key."
    }
  }
}
