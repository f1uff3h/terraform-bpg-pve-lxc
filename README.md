# terraform-bpg-pve-lxc

Based on [bpg's provider](https://github.com/bpg/terraform-provider-proxmox)

## Create an LXC container on PVE using Terraform

This module deploys an LXC container on ProxmoxVE host, with optional firewall configuration and LXC template download from URL.
Most variables either have defaults or inherit defaults from provider configuration. For a quick deployment only `ct_node` and `ct_os` are required.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.4 |
| <a name="requirement_proxmox"></a> [proxmox](#requirement\_proxmox) | >= 0.66 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3 |
| <a name="requirement_time"></a> [time](#requirement\_time) | ~> 0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_proxmox"></a> [proxmox](#provider\_proxmox) | >= 0.66 |
| <a name="provider_random"></a> [random](#provider\_random) | ~> 3 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |
| <a name="provider_time"></a> [time](#provider\_time) | ~> 0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [proxmox_virtual_environment_container.ct](https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_container) | resource |
| [proxmox_virtual_environment_download_file.ct_template](https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_download_file) | resource |
| [proxmox_virtual_environment_firewall_options.ct_fw_opts](https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_firewall_options) | resource |
| [proxmox_virtual_environment_firewall_rules.ct_fw_rules](https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_firewall_rules) | resource |
| [random_password.ct_root_pw](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [terraform_data.bootstrap_ct](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |
| [time_sleep.wait_for_ct](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_clone_target"></a> [clone\_target](#input\_clone\_target) | The target container to clone. | <pre>map(object({<br/>    vm_id        = optional(string)<br/>    node_name    = optional(string)<br/>    datastore_id = optional(string)<br/>  }))</pre> | `{}` | no |
| <a name="input_ct_bootstrap_script"></a> [ct\_bootstrap\_script](#input\_ct\_bootstrap\_script) | Path to script file ro run on container creation. | `string` | `null` | no |
| <a name="input_ct_console"></a> [ct\_console](#input\_ct\_console) | Console settings for the container. | <pre>object({<br/>    enabled   = optional(bool)<br/>    type      = optional(string)<br/>    tty_count = optional(number)<br/>  })</pre> | <pre>{<br/>  "enabled": true,<br/>  "type": "shell"<br/>}</pre> | no |
| <a name="input_ct_cpu"></a> [ct\_cpu](#input\_ct\_cpu) | Container CPU configuration. | <pre>object({<br/>    arch  = optional(string)<br/>    cores = optional(number)<br/>    units = optional(string)<br/>  })</pre> | `{}` | no |
| <a name="input_ct_disk"></a> [ct\_disk](#input\_ct\_disk) | Container storage. | <pre>object({<br/>    datastore = optional(string)<br/>    size      = optional(number)<br/>  })</pre> | `{}` | no |
| <a name="input_ct_dns"></a> [ct\_dns](#input\_ct\_dns) | DNS settings for the container. Map should contain maximum 1 object. Defined as map because empty dns block triggers a provider error. | <pre>object({<br/>    domain  = optional(string)<br/>    servers = optional(list(string))<br/>  })</pre> | `null` | no |
| <a name="input_ct_features"></a> [ct\_features](#input\_ct\_features) | Features to enable for the container. | <pre>object({<br/>    nesting = optional(bool)<br/>    fuse    = optional(bool)<br/>    keyctl  = optional(bool)<br/>    mount   = optional(list(string))<br/>  })</pre> | <pre>{<br/>  "nesting": true<br/>}</pre> | no |
| <a name="input_ct_fw"></a> [ct\_fw](#input\_ct\_fw) | Firewall settings for the container. | <pre>object({<br/>    enabled       = optional(bool)<br/>    dhcp          = optional(bool)<br/>    input_policy  = optional(string)<br/>    output_policy = optional(string)<br/>    log_level_in  = optional(string)<br/>    log_level_out = optional(string)<br/>    macfilter     = optional(bool)<br/>    ipfilter      = optional(bool)<br/>    ndp           = optional(bool)<br/>    radv          = optional(bool)<br/>  })</pre> | `{}` | no |
| <a name="input_ct_fw_fsg"></a> [ct\_fw\_fsg](#input\_ct\_fw\_fsg) | Firewall rules that import from a security group. | <pre>map(object({<br/>    enabled = optional(bool)<br/>    iface   = optional(string)<br/>    comment = optional(string)<br/>  }))</pre> | `{}` | no |
| <a name="input_ct_fw_rules"></a> [ct\_fw\_rules](#input\_ct\_fw\_rules) | Firewall rules for the container. | <pre>map(object({<br/>    enabled   = optional(bool)<br/>    action    = string<br/>    direction = string<br/>    sourceip  = optional(string)<br/>    destip    = optional(string)<br/>    sport     = optional(string)<br/>    dport     = optional(string)<br/>    proto     = optional(string)<br/>    log       = optional(string)<br/>    comment   = optional(string)<br/>  }))</pre> | `{}` | no |
| <a name="input_ct_id"></a> [ct\_id](#input\_ct\_id) | The ID of the container. | `number` | `null` | no |
| <a name="input_ct_init"></a> [ct\_init](#input\_ct\_init) | Initialization settings for the container. | <pre>object({<br/>    hostname  = optional(string)<br/>    root_pw   = optional(string)<br/>    root_keys = optional(list(string))<br/>  })</pre> | `{}` | no |
| <a name="input_ct_mem"></a> [ct\_mem](#input\_ct\_mem) | Container memory configuration. | <pre>object({<br/>    dedicated = optional(number)<br/>    swap      = optional(number)<br/>  })</pre> | `{}` | no |
| <a name="input_ct_net_ifaces"></a> [ct\_net\_ifaces](#input\_ct\_net\_ifaces) | Container network interfaces. | <pre>map(object({<br/>    name        = optional(string)<br/>    bridge      = optional(string)<br/>    enabled     = optional(bool)<br/>    firewall    = optional(bool)<br/>    mac_address = optional(string)<br/>    mtu         = optional(number)<br/>    rate_limit  = optional(string)<br/>    vlan_id     = optional(number)<br/>    ipv4_addr   = optional(string)<br/>    ipv4_gw     = optional(string)<br/>    ipv6_addr   = optional(string)<br/>    ipv6_gw     = optional(string)<br/>  }))</pre> | `{}` | no |
| <a name="input_ct_node"></a> [ct\_node](#input\_ct\_node) | The node on which to create the container. | `string` | n/a | yes |
| <a name="input_ct_os"></a> [ct\_os](#input\_ct\_os) | The template to use for the container. | `string` | `null` | no |
| <a name="input_ct_os_type"></a> [ct\_os\_type](#input\_ct\_os\_type) | The type of the OS template. Unmanaged means PVE won't manage the container (e.g. static IPs don't get auto assigned) | `string` | `"unmanaged"` | no |
| <a name="input_ct_os_upload"></a> [ct\_os\_upload](#input\_ct\_os\_upload) | Settings for uploading the OS template. | <pre>object({<br/>    datastore           = optional(string)<br/>    source              = optional(string)<br/>    checksum            = optional(string)<br/>    checksum_alg        = optional(string)<br/>    decomp_alg          = optional(string)<br/>    file_name           = optional(string)<br/>    overwrite           = optional(bool)<br/>    overwrite_unmanaged = optional(bool)<br/>    timeout             = optional(number)<br/>    verify              = optional(bool)<br/>  })</pre> | `{}` | no |
| <a name="input_ct_pool"></a> [ct\_pool](#input\_ct\_pool) | The pool in which to create the container. | `string` | `null` | no |
| <a name="input_ct_protection"></a> [ct\_protection](#input\_ct\_protection) | Whether protection is enabled on the container. | `bool` | `false` | no |
| <a name="input_ct_ssh_privkey"></a> [ct\_ssh\_privkey](#input\_ct\_ssh\_privkey) | File containing ssh private key to be used for container bootstrap. | `string` | `null` | no |
| <a name="input_ct_start"></a> [ct\_start](#input\_ct\_start) | The start settings for the container. | <pre>object({<br/>    on_deploy  = bool<br/>    on_boot    = bool<br/>    order      = optional(number)<br/>    up_delay   = optional(number)<br/>    down_delay = optional(number)<br/>  })</pre> | <pre>{<br/>  "down_delay": 0,<br/>  "on_boot": false,<br/>  "on_deploy": true,<br/>  "order": 0,<br/>  "up_delay": 0<br/>}</pre> | no |
| <a name="input_ct_tags"></a> [ct\_tags](#input\_ct\_tags) | The tags to apply to the container. | `list(string)` | `[]` | no |
| <a name="input_ct_template"></a> [ct\_template](#input\_ct\_template) | Whether the container is a template. | `bool` | `false` | no |
| <a name="input_ct_unprivileged"></a> [ct\_unprivileged](#input\_ct\_unprivileged) | Whether the container should be unprivileged. | `bool` | `true` | no |

## Outputs

No outputs.
