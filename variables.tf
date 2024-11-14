variable "ct_node" {
  type        = string
  description = "The node on which to create the container."
}

variable "ct_pool" {
  type        = string
  description = "The pool in which to create the container."
  nullable    = true
  default     = null
}

variable "ct_start" {
  type = object({
    on_deploy  = bool
    on_boot    = bool
    order      = optional(number)
    up_delay   = optional(number)
    down_delay = optional(number)
  })
  description = "The start settings for the container."
  default = {
    on_deploy  = true
    on_boot    = false
    order      = 0
    up_delay   = 0
    down_delay = 0
  }
}

variable "ct_protection" {
  type        = bool
  description = "Whether protection is enabled on the container."
  default     = false
}

variable "ct_unprivileged" {
  type        = bool
  description = "Whether the container should be unprivileged."
  default     = true
}

variable "ct_id" {
  type        = number
  description = "The ID of the container."
  default     = null
}

variable "ct_cpu" {
  type = object({
    arch  = optional(string)
    cores = optional(number)
    units = optional(string)
  })
  description = "Container CPU configuration."
  default     = {}
}

variable "ct_mem" {
  type = object({
    dedicated = optional(number)
    swap      = optional(number)
  })
  description = "Container memory configuration."
  default     = {}
}

variable "ct_disk" {
  type = object({
    datastore = optional(string)
    size      = optional(number)
  })
  description = "Container storage."
  default     = {}
}

variable "ct_net_ifaces" {
  type = map(object({
    name        = optional(string)
    bridge      = optional(string)
    enabled     = optional(bool)
    firewall    = optional(bool)
    mac_address = optional(string)
    mtu         = optional(number)
    rate_limit  = optional(string)
    vlan_id     = optional(number)
    ipv4_addr   = optional(string)
    ipv4_gw     = optional(string)
    ipv6_addr   = optional(string)
    ipv6_gw     = optional(string)
  }))
  description = "Container network interfaces."
  default     = {}
}

variable "clone_target" {
  type = map(object({
    vm_id        = optional(string)
    node_name    = optional(string)
    datastore_id = optional(string)
  }))
  description = "The target container to clone."
  nullable    = true
  default     = {}
}

variable "ct_os" {
  type        = string
  description = "The template to use for the container."
  default     = null
}

variable "ct_os_type" {
  type        = string
  description = "The type of the OS template. Unmanaged means PVE won't manage the container (e.g. static IPs don't get auto assigned)"
  default     = "unmanaged"
}

variable "ct_os_upload" {
  type = object({
    datastore           = optional(string)
    source              = optional(string)
    checksum            = optional(string)
    checksum_alg        = optional(string)
    decomp_alg          = optional(string)
    file_name           = optional(string)
    overwrite           = optional(bool)
    overwrite_unmanaged = optional(bool)
    timeout             = optional(number)
    verify              = optional(bool)
  })
  description = "Settings for uploading the OS template."
  default     = {}
}

variable "ct_console" {
  type = object({
    enabled   = optional(bool)
    type      = optional(string)
    tty_count = optional(number)
  })
  description = "Console settings for the container."
  nullable    = true
  default = {
    enabled = true
    type    = "shell"
  }
}

variable "ct_init" {
  type = object({
    hostname  = optional(string)
    root_pw   = optional(string)
    root_keys = optional(list(string))
  })
  description = "Initialization settings for the container."
  default     = {}
}

variable "ct_dns" {
  type = object({
    domain  = optional(string)
    servers = optional(list(string))
  })
  description = "DNS settings for the container. Map should contain maximum 1 object. Defined as map because empty dns block triggers a provider error."
  default     = null
}

variable "ct_tags" {
  type        = list(string)
  description = "The tags to apply to the container."
  default     = []
}

variable "ct_features" {
  type = object({
    nesting = optional(bool)
    fuse    = optional(bool)
    keyctl  = optional(bool)
    mount   = optional(list(string))
  })
  description = "Features to enable for the container."
  nullable    = true
  default = {
    nesting = true
  }
}

variable "ct_template" {
  type        = bool
  description = "Whether the container is a template."
  default     = false
}

variable "ct_fw" {
  type = object({
    enabled       = optional(bool)
    dhcp          = optional(bool)
    input_policy  = optional(string)
    output_policy = optional(string)
    log_level_in  = optional(string)
    log_level_out = optional(string)
    macfilter     = optional(bool)
    ipfilter      = optional(bool)
    ndp           = optional(bool)
    radv          = optional(bool)
  })
  description = "Firewall settings for the container."
  default     = {}
}

variable "ct_fw_rules" {
  type = map(object({
    enabled   = optional(bool)
    action    = string
    direction = string
    sourceip  = optional(string)
    destip    = optional(string)
    sport     = optional(string)
    dport     = optional(string)
    proto     = optional(string)
    log       = optional(string)
    comment   = optional(string)
  }))
  description = "Firewall rules for the container."
  default     = {}
}

variable "ct_fw_fsg" {
  type = map(object({
    enabled = optional(bool)
    iface   = optional(string)
    comment = optional(string)
  }))
  description = "Firewall rules that import from a security group."
  default     = {}
}

variable "ct_ssh_privkey" {
  type        = string
  description = "File containing ssh private key to be used for container bootstrap."
  default     = null
}

variable "ct_bootstrap" {
  type = map(object({
    script_path = optional(string)
    arguments   = optional(string)
  }))
  description = "List of paths to script files to be executed after container creation. Scripts will be executed in the order provided."
  default     = {}
}
