# COMMON DATA SOURCES

# Availability Domains
data oci_identity_availability_domains ADs {
  compartment_id = var.tenancy_ocid
}

# Oracle Linux VM Image
data oci_core_images oraclelinux {
  compartment_id = var.compartment_ocid

  operating_system         = "Oracle Linux"
  operating_system_version = "7.6"

  # exclude GPU specific images
  filter {
    name   = "display_name"
    values = ["^Oracle-Linux-7.6-([\\.0-9]+)-([\\.0-9-]+)$"]
    regex  = true
  }
}

