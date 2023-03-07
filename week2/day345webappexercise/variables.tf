# Define student name to be used in constructing the prefix for resource names
variable "student" {
  default = "alexg"
}

# Define project name to be used in constructing the prefix for resource names
variable "project" {
  default = "day345webappexercise"
}

# Define separator character to be used in constructing the prefix for resource names
variable "separator" {
  default = "-"
}

# Define prefix for resource names
locals {
  prefix = join(var.separator, [var.student, var.project])
}

# Define Resource Group name and location
variable "rg_postfix" {
  default = "rg"
}
locals {
  rg_name = join(var.separator, [local.prefix, var.rg_postfix])
}
variable "rg_location" {
  default = "uksouth"
}

# Define Virtual Network name and CIDR
variable "vnet_postfix" {
  default = "wa-vnet"
}
locals {
  vnet_name = join(var.separator, [local.prefix, var.vnet_postfix])
}
variable "vnet_cidr" {
  default = ["10.0.0.0/16"]
}

# Define Web App subnet variables
variable "subnet_wa_postfix" {
  default = "webapp-subnet"
}
variable "subnet_wa_delegation_postfix" {
  default = "delegation"
}
locals {
  subnet_wa_name = join(var.separator, [local.prefix, var.subnet_wa_postfix])
  subnet_wa_delegation_name = join(var.separator, [local.subnet_wa_name, var.subnet_wa_delegation_postfix])
}
variable "subnet_wa_cidr" {
  default = ["10.0.1.0/24"]
}
variable "subnet_wa_service_delegation_name" {
  default = "Microsoft.Web/serverFarms"
}
variable "subnet_wa_service_delegation_actions" {
  default = ["Microsoft.Network/virtualNetworks/subnets/action"]
}

# Define DB subnet variables
variable "subnet_db_postfix" {
  default = "db-subnet"
}
locals {
  subnet_db_name = join(var.separator, [local.prefix, var.subnet_db_postfix])
}
variable "subnet_db_cidr" {
  default = ["10.0.2.0/24"]
}

# Define Key Vault subnet variables
variable "subnet_kv_postfix" {
  default = "kv-subnet"
}
locals {
  subnet_kv_name = join(var.separator, [local.prefix, var.subnet_kv_postfix])
}
variable "subnet_kv_cidr" {
  default = ["10.0.3.0/24"]
}

# Define Service Plan variables
variable "sp_postfix" {
  default = "asp"
}
locals {
  sp_name = join(var.separator, [local.prefix, var.sp_postfix])
}
variable "sp_os" {
  default = "Linux"
}
variable "sp_sku" {
  default = "S1"
}

# Define Web App variables
variable "wa_postfix" {
  default = "wa"
}
locals {
  wa_name = join(var.separator, [local.prefix, var.wa_postfix])
}

# Define Key Vault variables
variable "kv_postfix" {
  default = "kv"
}
locals {
  # Issue with Azure allowing only a max of 24 chars in KV names
  # Hardcode a slightly shorter name as a workaround
  # kv_name = join(var.separator, [local.prefix, var.kv_postfix])
  kv_name = join(var.separator, ["alexg-day345exercise", var.kv_postfix])
}
variable "kv_sku" {
  default = "standard"
}
variable "kv_days" {
  default = 7
}
variable "kv_purge" {
  default = false
}
variable "kv_policy_secrets" {
  default = [
    "List",
    "Set",
    "Get",
    "Delete",
    "Purge",
    "Recover"
  ]
}

# Define password variables
variable "pwd_length" {
  default = 16
}

# Define Key Vault Secret variables
variable "kvs_postfix" {
  default = "kvs"
}
locals {
  kvs_name = join(var.separator, [local.prefix, var.kvs_postfix])
}

# Define PostgreSQL Server and DB variables
variable "dbs_postfix" {
  default = "psql"
}
variable "db_postfix" {
  default = "db"
}
locals {
  dbs_name = join(var.separator, [local.prefix, var.dbs_postfix])
  db_name = join(var.separator, [local.prefix, var.db_postfix])
}
variable "dbs_sku" {
  default = "GP_Gen5_2"
}
variable "dbs_version" {
  default = "11"
}
variable "dbs_size" {
  default = 8192
}
variable "dbs_days" {
  default = 30
}
variable "dbs_geo_backup" {
  default = false
}
variable "dbs_auto_grow" {
  default = true
}
variable "dbs_ssl_enforce" {
  default = true
}
variable "dbs_admin_user" {
  default = "psqladmin"
}
variable "db_charset" {
  default = "UTF8"
}
variable "db_collation" {
  default = "English_United States.1252"
}

# Define Private DNS Zone variables
variable "dnsz_name" {
  default = "privatelink.postgres.database.azure.com"
}
variable "dnsl_postfix" {
  default = "dns-link"
}
locals {
  dnsl_name = join(var.separator, [local.prefix, var.dnsl_postfix])
}

# Define Private Endpoint variables
variable "pe_postfix" {
  default = "psql-pe"
}
variable "psc_postfix" {
  default = "psc"
}
locals {
  pe_name = join(var.separator, [local.prefix, var.pe_postfix])
  psc_name = join(var.separator, [local.prefix, var.psc_postfix])
}
variable "psc_subresources" {
  default = ["postgresqlServer"]
}
variable "psc_manual" {
  default = false
}
variable "dnszg_name" {
  default = "privatelink-postgres-database-azure-com"
}
