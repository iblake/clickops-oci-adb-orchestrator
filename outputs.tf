output "autonomous_databases" {
  description = "The autonomous databases, indexed by keys."
  value = {
    for adb_key, adb in oci_database_autonomous_database.autonomous_databases : 
    adb_key => {
      # Información básica
      id           = adb.id
      display_name = adb.display_name
      db_name      = adb.db_name
      
      # Estado y configuración
      state                       = adb.state
      cpu_core_count              = adb.cpu_core_count
      data_storage_size_in_tbs    = adb.data_storage_size_in_tbs
      compute_model               = adb.compute_model
      db_workload                 = adb.db_workload
      
      # URLs y conexiones
      service_console_url = adb.service_console_url
      connection_strings = {
        all_connection_strings = adb.connection_strings
        high                  = try(adb.connection_strings[0].all_connection_strings["HIGH"], "")
        medium                = try(adb.connection_strings[0].all_connection_strings["MEDIUM"], "")
        low                   = try(adb.connection_strings[0].all_connection_strings["LOW"], "")
      }
      
      # Información de red
      subnet_id              = adb.subnet_id
      private_endpoint       = adb.private_endpoint
      private_endpoint_ip    = adb.private_endpoint_ip
      private_endpoint_label = adb.private_endpoint_label
      
      # Configuración de seguridad
      is_mtls_connection_required = adb.is_mtls_connection_required
      kms_key_id                  = adb.kms_key_id
      
      # Información de escalado
      is_auto_scaling_enabled              = adb.is_auto_scaling_enabled
      is_auto_scaling_for_storage_enabled  = adb.is_auto_scaling_for_storage_enabled
      
      # Información temporal
      time_created = adb.time_created
      
      # OCID del compartment
      compartment_id = adb.compartment_id
    }
  }
}

output "autonomous_databases_ids" {
  description = "The autonomous databases OCIDs, indexed by keys."
  value = {
    for adb_key, adb in oci_database_autonomous_database.autonomous_databases : 
    adb_key => adb.id
  }
}

output "autonomous_databases_connection_strings" {
  description = "The autonomous databases connection strings, indexed by keys."
  value = {
    for adb_key, adb in oci_database_autonomous_database.autonomous_databases : 
    adb_key => {
      high   = try(adb.connection_strings[0].all_connection_strings["HIGH"], "")
      medium = try(adb.connection_strings[0].all_connection_strings["MEDIUM"], "")
      low    = try(adb.connection_strings[0].all_connection_strings["LOW"], "")
    }
  }
  sensitive = true
}