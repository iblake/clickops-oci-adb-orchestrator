variable "autonomous_databases_configuration" {
  description = "Autonomous Database configuration compatible with OCI Landing Zone orchestrator"
  type        = any
  default     = null
}

variable "compartments_dependency" {
  description = "A map of objects containing the externally managed compartments this module may depend on. All map objects must have the same type and must contain an 'id' attribute of string type set with the compartment OCID."
  type = map(object({
    id = string
  }))
  default = null
}

variable "network_dependency" {
  description = "A map of objects containing the externally managed networking resources this module may depend on."
  type = object({
    vcns = optional(map(object({
      id = string
    })))
    subnets = optional(map(object({
      id = string
    })))
    network_security_groups = optional(map(object({
      id = string
    })))
    dynamic_routing_gateways = optional(map(object({
      id = string
    })))
    drg_attachments = optional(map(object({
      id = string
    })))
    local_peering_gateways = optional(map(object({
      id = string
    })))
    remote_peering_connections = optional(map(object({
      id = string
      region_name = string
    })))
  })
  default = null
}

variable "kms_dependency" {
  description = "A map of objects containing the externally managed encryption keys this module may depend on."
  type = map(object({
    id = string
  }))
  default = null
}