# Terraform OCI Autonomous Database Module for LZ orchestrator

This module provisions one or more **Autonomous Databases (ADB)** in **Oracle Cloud Infrastructure (OCI)**, designed for seamless integration with the **OCI Landing Zone Orchestrator**. It supports flexible configuration, dependency resolution, and advanced networking and security options.

---

## Features

- **Orchestrator compatible**: Designed for use with the OCI Landing Zone Orchestrator.
- **Multiple ADBs**: Deploy multiple databases from a single configuration.
- **Automatic dependency resolution**: Compartments, networking, KMS.
- **Supported workloads**: OLTP, DW, AJD, APEX.
- **Flexible resource and networking configuration**.
- **Automatic and customizable tags**.
- **Supports Always Free Tier**.

---

## Usage

Add the following to your `database.tf`:

```hcl
module "oci_lz_autonomous_databases" {
  count  = var.autonomous_databases_configuration != null ? 1 : 0
  source = "git::https://github.com/iblake/clickops-oci-adb-orchestrator.git//module"
  providers = {
    oci = oci
  }
  autonomous_databases_configuration = var.autonomous_databases_configuration
  compartments_dependency            = local.compartments_dependency
  network_dependency                 = local.network_dependency
  kms_dependency                     = local.kms_dependency
}
```

The input variable `autonomous_databases_configuration` should be provided as shown in the JSON examples in the following sections.

---

## Input Configuration

### Main Structure

The main input is a JSON object with the following structure:

```json
{
  "autonomous_databases_configuration": {
    "default_compartment_id": "ocid1.compartment.oc1..xxxx",
    "default_defined_tags": {},
    "default_freeform_tags": {
      "Project": "example",
      "ManagedBy": "terraform-orchestrator"
    },
    "autonomous_databases": {
      "adb-key": {
        "db_name": "MYADB",
        "admin_password": "XXXXXXXXXXXX"
      }
    }
  }
}
```

#### Key Parameters

| Parameter                        | Type            | Required | Description                                                      |
|-----------------------------------|-----------------|----------|------------------------------------------------------------------|
| default_compartment_id            | string          | Yes      | Default compartment OCID                                         |
| default_defined_tags              | map(string)     | No       | Default defined tags                                             |
| default_freeform_tags             | map(string)     | No       | Default freeform tags                                            |
| autonomous_databases              | map(object)     | Yes      | Map of ADB definitions (see below)                               |

#### Autonomous Database Object

| Parameter                        | Type            | Default              | Description                                                      |
|-----------------------------------|-----------------|----------------------|------------------------------------------------------------------|
| compartment_id                    | string          | null                 | Compartment OCID (null = use default)                            |
| db_name                           | string          | -                    | Database name (1-14 chars, letters/numbers, must start with a letter) |
| display_name                      | string          | db_name              | Display name                                                     |
| cpu_core_count                    | number          | 1                    | Number of ECPUs/OCPUs                                            |
| data_storage_size_in_tbs          | number          | 1                    | Storage in TB                                                    |
| compute_model                     | string          | "ECPU"               | "ECPU" or "OCPU"                                                 |
| db_workload                       | string          | "OLTP"               | "OLTP", "DW", "AJD", "APEX"                                      |
| db_version                        | string          | "19c"                | "19c", "21c", "23c"                                              |
| is_auto_scaling_enabled           | bool            | false                | Enable CPU auto-scaling                                          |
| is_auto_scaling_for_storage_enabled| bool           | false                | Enable storage auto-scaling                                      |
| license_model                     | string          | "BRING_YOUR_OWN_LICENSE"   | "LICENSE_INCLUDED" or "BRING_YOUR_OWN_LICENSE"                   |
| admin_password                    | string          | null                 | Admin password (null = auto-generated)                           |
| is_mtls_connection_required       | bool            | false                | Require mTLS (wallet)                                            |
| subnet_id                         | string          | null                 | Subnet OCID or dependency key (null = public ADB)                |
| nsg_ids                           | list(string)    | []                   | List of NSG OCIDs or dependency keys                             |
| private_endpoint_label            | string          | null                 | Private endpoint label (if subnet_id is set)                     |
| is_free_tier                      | bool            | false                | Use Always Free Tier                                             |
| is_dedicated                      | bool            | false                | Dedicated Exadata infrastructure                                 |
| kms_key_id                        | string          | null                 | KMS key OCID or dependency key                                   |
| defined_tags                      | map(string)     | {}                   | Defined tags (merged with default)                               |
| freeform_tags                     | map(string)     | {}                   | Freeform tags (merged with default)                              |

---

## Examples

### 1. Minimal and Simple ADB Deployment

This example creates a basic ADB with the minimum required configuration.

```json
{
  "tenancy_ocid": "ocid1.tenancy.oc1..xxxxxxxxxxxxxxxxxxx",
  "user_ocid": "ocid1.user.oc1..xxxxxxxxxxxxxxxxxxxxxx", 
  "fingerprint": "ad:14:82:7a:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx",
  "private_key_path": "~/.oci/xxxxx.pem",
  "region": "eu-frankfurt-1",
  
  "autonomous_databases_configuration": {
    "default_compartment_id": "ocid1.compartment.oc1..xxxxxxxxxxxxxxxxx",
    "default_defined_tags": {},
    "default_freeform_tags": {
      "Project": "enterprise-app",
      "ManagedBy": "terraform-orchestrator",
      "Service": "autonomous-database",
      "CostCenter": "IT-Database",
      "Environment": "Production"
    },
    
    "autonomous_databases": {
      "atp-app1": {
        "db_name": "dgcADB1",
        "display_name": "ATP Application 1",
        "compartment_id": null,
        "cpu_core_count": 1,
        "data_storage_size_in_tbs": 1,
        "compute_model": "ECPU",
        "db_workload": "OLTP",
        "db_version": "19c",
        "is_auto_scaling_enabled": false,
        "is_auto_scaling_for_storage_enabled": false,
        "license_model": "BRING_YOUR_OWN_LICENSE",
        "admin_password": "XXXXXXXXXXXX",
        "is_mtls_connection_required": true,
        "subnet_id": null,
        "nsg_ids": [],
        "private_endpoint_label": null,
        "is_free_tier": false,
        "is_dedicated": false,
        "kms_key_id": null,
        "freeform_tags": {
          "Application": "web-frontend",
          "Tier": "database"
        }
      }
    }
  }
}
```

### 2. Minimal and Simple Two ADB Deployment

This example creates two basic ADBs with minimal configuration.

```json
{
  "tenancy_ocid": "ocid1.tenancy.oc1..xxxxxxxxxxxxxxxxxxx",
  "user_ocid": "ocid1.user.oc1..xxxxxxxxxxxxxxxxxxxxxx", 
  "fingerprint": "ad:14:82:7a:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx",
  "private_key_path": "~/.oci/xxxxx.pem",
  "region": "eu-frankfurt-1",
  
  "autonomous_databases_configuration": {
    "default_compartment_id": "ocid1.compartment.oc1..xxxxxxxxxxxxxxxxx",
    "default_defined_tags": {},
    "default_freeform_tags": {
      "Project": "enterprise-app",
      "ManagedBy": "terraform-orchestrator",
      "Service": "autonomous-database",
      "CostCenter": "IT-Database",
      "Environment": "Production"
    },
    
    "autonomous_databases": {
      "atp-app1": {
        "db_name": "dgcADB1",
        "display_name": "ATP Application 1",
        "compartment_id": null,
        "cpu_core_count": 1,
        "data_storage_size_in_tbs": 1,
        "compute_model": "ECPU",
        "db_workload": "OLTP",
        "db_version": "19c",
        "is_auto_scaling_enabled": false,
        "is_auto_scaling_for_storage_enabled": false,
        "license_model": "BRING_YOUR_OWN_LICENSE",
        "admin_password": "WelcomeOracle123#",
        "is_mtls_connection_required": true,
        "subnet_id": null,
        "nsg_ids": [],
        "private_endpoint_label": null,
        "is_free_tier": false,
        "is_dedicated": false,
        "kms_key_id": null,
        "freeform_tags": {
          "Application": "web-frontend",
          "Tier": "database"
        }
      },
      
      "atp-app2": {
        "db_name": "dgcADB2",
        "display_name": "ATP Application 2",
        "compartment_id": null,
        "cpu_core_count": 1,
        "data_storage_size_in_tbs": 1,
        "compute_model": "ECPU",
        "db_workload": "OLTP",
        "db_version": "19c",
        "is_auto_scaling_enabled": false,
        "is_auto_scaling_for_storage_enabled": false,
        "license_model": "BRING_YOUR_OWN_LICENSE",
        "admin_password": "WelcomeOracle123#",
        "is_mtls_connection_required": true,
        "subnet_id": null,
        "nsg_ids": [],
        "private_endpoint_label": null,
        "is_free_tier": false,
        "is_dedicated": false,
        "kms_key_id": null,
        "freeform_tags": {
          "Application": "analytics-backend",
          "Tier": "database"
        }
      }
    }
  }
}
```

### 3. Deploying an ADB in an Existing Network

This example provisions an ADB in a private subnet and attaches it to existing NSGs. You can use either OCIDs or dependency keys for subnet and NSGs.

```json
{
  "tenancy_ocid": "ocid1.tenancy.oc1..xxxx",
  "user_ocid": "ocid1.user.oc1..xxxx",
  "fingerprint": "xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx",
  "private_key_path": "~/.oci/xxxxx.pem",
  "region": "eu-madrid-1",
  "autonomous_databases_configuration": {
    "default_compartment_id": "ocid1.compartment.oc1..xxxx",
    "autonomous_databases": {
      "networked-adb": {
        "db_name": "NETADB",
        "display_name": "Networked Autonomous Database",
        "cpu_core_count": 1,
        "data_storage_size_in_tbs": 1,
        "compute_model": "ECPU",
        "db_workload": "OLTP",
        "db_version": "19c",
        "is_auto_scaling_enabled": true,
        "license_model": "BRING_YOUR_OWN_LICENSE",
        "admin_password": "XXXXXXXXXXXXXX",
        "is_mtls_connection_required": true,
        "subnet_id": "ocid1.subnet.oc1..xxxx",
        "nsg_ids": [
          "ocid1.networksecuritygroup.oc1..xxxx"
        ],
        "private_endpoint_label": "adb-private-endpoint",
        "is_free_tier": false,
        "freeform_tags": {
          "Application": "erp",
          "Tier": "database"
        }
      }
    }
  }
}
```

---

## Outputs

- `autonomous_databases`: Full information for each created ADB (OCID, state, endpoints, etc.).
- `autonomous_databases_ids`: OCIDs of the ADBs.
- `autonomous_databases_connection_strings`: Connection strings (HIGH, MEDIUM, LOW) for each ADB.

---

## Notes & Best Practices

- If you use keys instead of OCIDs for subnets, NSGs, or compartments, provide the correct dependency files.
- The admin password must meet Oracle requirements (12–30 characters, 2 uppercase, 2 lowercase, 2 numbers, 2 special characters, must not contain "admin").
