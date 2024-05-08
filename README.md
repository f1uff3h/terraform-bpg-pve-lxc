# terraform-bpg-pve-lxc
Based on [bpg's provider](https://github.com/bpg/terraform-provider-proxmox)

## Create an LXC container on PVE using Terraform
This module deploys an LXC container on ProxmoxVE host, with optional firewall configuration and LXC template download from URL.
Most variables either have defaults or inherit defaults from provider configuration. For a quick deployment only `ct-node` and `ct-os` are required.

## Inputs

| NAME | Description | Type | Default | Required |
| --- | --- | --- | --- | --- |
| ct-root-pw | The root password for the container's root account. If unset a random password will be generated | string | null | No |
| ct-node | The node on which to create the container | string | - | Yes |
| ct-pool | The pool in which to create the container | string | null | No |
| ct-start | Settings related to container startup/shutdown | object | { on-deploy: true, on-boot: false } | No |
| ct-unprivileged | Whether the container should be unprivileged | bool | true | No |
| ct-id | The ID of the container | number | null | No |
| ct-cpu | Container CPU configuration | object | {} | No |
| ct-mem | Container memory configuration | object | {} | No |
| ct-disk | Container storage | object | {} | No |
| ct-net-ifaces | Containers network interfaces | map | {} | No |
| clone-target | The target container to clone | map | {} | No |
| ct-os | The template to use for the container If set `ct-os-upload` will be ignored | string | null | No |
| ct-os-upload | Settings for uploading the OS template to use. Ignored if `ct-os` is set | object | {} | No |
| ct-console | Console settings for the container | object | { enabled: true, type: "shell" } | No |
| ct-init | Initialization settings for the container | object | {} | No |
| ct-dns | DNS settings for the container | map | {} | No |
| ct-tags | The tags to apply to the container | list | [] | No |
| ct-features | Features to enable for the container. Requires root account for anything other than nesting | object | { nesting: true } | No |
| ct-template | Whether the container is a template | bool | false | No |
| ct-fw | Firewall settings and firewall rules for the container | object | { options: {}, rules: {} } | No |