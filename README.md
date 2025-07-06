# Terraform OCI Autonomous Database Module

This module creates multiple **Autonomous Databases** in **Oracle Cloud Infrastructure (OCI)** and is specifically designed to integrate with the **OCI Landing Zone Orchestrator**.

## Features

* ✅ **Compatible** with the OCI Landing Zone Orchestrator
* ✅ **Multiple ADBs** from a single configuration
* ✅ **Automatic dependency resolution** (compartments, networking, KMS)
* ✅ **Supported workloads**: OLTP, DW, AJD, APEX
* ✅ **Flexible configuration** for resources and networking
* ✅ **Automatic and customizable tags**

## Usage

```hcl
module "autonomous_databases" {
  source = "./modules/terraform-oci-adb"
  
  autonomous_databases_configuration = var.autonomous_databases_configuration
  compartments_dependency             = local.compartments_dependency
  network_dependency                  = local.network_dependency
  kms_dependency                      = local.kms_dependency
}
```

## Input Configuration

### Basic Structure

```hcl
variable "autonomous_databases_configuration" {
  type = object({
    default_compartment_id = string
    default_defined_tags   = optional(map(string), {})
    default_freeform_tags  = optional(map(string), {})
    
    autonomous_databases = map(object({
      compartment_id                        = optional(string)
      db_name                               = string
      display_name                          = optional(string)
      cpu_core_count                        = optional(number, 1)
      data_storage_size_in_tbs              = optional(number, 1)
      compute_model                         = optional(string, "ECPU")
      db_workload                           = optional(string, "OLTP")
      db_version                            = optional(string, "19c")
      is_auto_scaling_enabled               = optional(bool, false)
      is_auto_scaling_for_storage_enabled   = optional(bool, false)
      license_model                         = optional(string, "LICENSE_INCLUDED")
      admin_password                        = optional(string)
      is_mtls_connection_required           = optional(bool, false)
      subnet_id                             = optional(string)
      nsg_ids                               = optional(list(string), [])
      private_endpoint_label                = optional(string)
      is_free_tier                          = optional(bool, false)
      is_dedicated                          = optional(bool, false)
      kms_key_id                            = optional(string)
      defined_tags                          = optional(map(string))
      freeform_tags                         = optional(map(string))
    }))
  })
}
```

## Dependency Variables

### `compartments_dependency`

Map of available compartments provided by the orchestrator:

```hcl
{
  "app-compartment" = {
    id = "ocid1.compartment.oc1..aaaaaaaa..."
  }
}
```