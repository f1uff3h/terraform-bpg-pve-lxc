variable "ct-node" {
  type        = string
  description = "The node on which to create the container."
}

variable "ct-pool" {
  type        = string
  description = "The pool in which to create the container."
  nullable    = true
  default     = null
}

variable "ct-start" {
  type = object({
    on-deploy  = bool
    on-boot    = bool
    order      = optional(number)
    up-delay   = optional(number)
    down-delay = optional(number)
  })
  description = "The start settings for the container."
  default = {
    on-deploy  = true
    on-boot    = false
    order      = 0
    up-delay   = 0
    down-delay = 0
  }
}

variable "ct-unprivileged" {
  type        = bool
  description = "Whether the container should be unprivileged."
  default     = true
}

variable "ct-id" {
  type        = number
  description = "The ID of the container."
  default     = null
}

variable "ct-cpu" {
  type = object({
    arch  = optional(string)
    cores = optional(number)
    units = optional(string)
  })
  description = "Container CPU configuration."
  default     = {}
}

variable "ct-mem" {
  type = object({
    dedicated = optional(number)
    swap      = optional(number)
  })
  description = "Container memory configuration."
  default     = {}
}

variable "ct-disk" {
  type = object({
    datastore = optional(string)
    size      = optional(number)
  })
  description = "Container storage."
  default     = {}
}

variable "ct-net-ifaces" {
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

variable "clone-target" {
  type = map(object({
    vm_id        = optional(string)
    node_name    = optional(string)
    datastore_id = optional(string)
  }))
  description = "The target container to clone."
  nullable    = true
  default     = {}
}

variable "ct-os" {
  type        = string
  description = "The template to use for the container."
  default     = null
}

variable "ct-os-type" {
  type        = string
  description = "The type of the OS template. Unmanaged means PVE won't manage the container (e.g. static IPs don't get auto assigned)"
  default     = "unmanaged"
}

variable "ct-os-upload" {
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

variable "ct-console" {
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

variable "ct-init" {
  type = object({
    hostname  = optional(string)
    root_pw   = optional(string)
    root_keys = optional(list(string))
  })
  description = "Initialization settings for the container."
  default     = {}
}

variable "ct-dns" {
  type = object({
    domain  = optional(string)
    servers = optional(list(string))
  })
  description = "DNS settings for the container. Map should contain maximum 1 object. Defined as map because empty dns block triggers a provider error."
  default     = null
}

variable "ct-tags" {
  type        = list(string)
  description = "The tags to apply to the container."
  default     = []
}

variable "ct-features" {
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

variable "ct-template" {
  type        = bool
  description = "Whether the container is a template."
  default     = false
}

variable "ct-fw" {
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

variable "ct-fw-rules" {
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

variable "ct-fw-fsg" {
  type = map(object({
    enabled = optional(bool)
    iface   = optional(string)
    comment = optional(string)
  }))
  description = "Firewall rules that import from a security group."
  default     = {}
}

variable "ct-ssh-privkey" {
  type        = string
  description = "File containing ssh private key to be used for container bootstrap."
  default     = null
}

variable "ct-bootstrap-script" {
  type        = string
  description = "Path to script file ro run on container creation."
  default     = null
}
