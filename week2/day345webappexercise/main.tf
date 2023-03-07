# Define Provider Client Configuration to access tenant and object IDs later on
data "azurerm_client_config" "current" {}

# Define Resource Group
resource "azurerm_resource_group" "rg" {
  name = local.rg_name
  location = var.rg_location
}

# Define Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name = local.vnet_name
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space = var.vnet_cidr
}

# Define WebApp subnet
resource "azurerm_subnet" "subnet_wa" {
  name = local.subnet_wa_name
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = var.subnet_wa_cidr

  delegation {
    name = local.subnet_wa_delegation_name

    service_delegation {
      name = var.subnet_wa_service_delegation_name
      actions = var.subnet_wa_service_delegation_actions
    }
  }
}

# Define DB subnet
resource "azurerm_subnet" "subnet_db" {
  name = local.subnet_db_name
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = var.subnet_db_cidr
}

# Define Key Vault subnet
resource "azurerm_subnet" "subnet_kv" {
  name = local.subnet_kv_name
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = var.subnet_kv_cidr
}

# Define Service Plan
resource "azurerm_service_plan" "sp" {
  name = local.sp_name
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  os_type = var.sp_os
  sku_name = var.sp_sku
}

# Define Web App
resource "azurerm_linux_web_app" "wa" {
  name = local.wa_name
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_service_plan.sp.location
  service_plan_id = azurerm_service_plan.sp.id
  virtual_network_subnet_id = azurerm_subnet.subnet_wa.id

  site_config {
  }
}

# Define Key Vault
resource "azurerm_key_vault" "kv" {
  name = local.kv_name
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tenant_id = data.azurerm_client_config.current.tenant_id
  sku_name = var.kv_sku
  soft_delete_retention_days = var.kv_days
  purge_protection_enabled = var.kv_purge

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = var.kv_policy_secrets
  }
}

# Define 16 char long random password
resource "random_password" "pwd" {
  length = var.pwd_length
}

# Define Key Vault Secret
resource "azurerm_key_vault_secret" "kvs" {
  name  = local.kvs_name
  value = random_password.pwd.result
  key_vault_id = azurerm_key_vault.kv.id
}

# Define PostgreSQL Server
resource "azurerm_postgresql_server" "dbs" {
  name = local.dbs_name
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location

  sku_name = var.dbs_sku
  version = var.dbs_version
  storage_mb = var.dbs_size
  backup_retention_days = var.dbs_days
  geo_redundant_backup_enabled = var.dbs_geo_backup
  auto_grow_enabled = var.dbs_auto_grow
  ssl_enforcement_enabled = var.dbs_ssl_enforce

  administrator_login = var.dbs_admin_user
  administrator_login_password = azurerm_key_vault_secret.kvs.value
}

# Define PostgreSQL DB
resource "azurerm_postgresql_database" "db" {
  name = local.db_name
  resource_group_name = azurerm_resource_group.rg.name
  server_name = azurerm_postgresql_server.dbs.name
  charset = var.db_charset
  collation = var.db_collation
}

# Define Private DNS Zone
resource "azurerm_private_dns_zone" "dnsz" {
  name = var.dnsz_name
  resource_group_name = azurerm_resource_group.rg.name
}

# Define link between Private DNS Zone and Virtual Network
resource "azurerm_private_dns_zone_virtual_network_link" "dnsl" {
  name = local.dnsl_name
  resource_group_name = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.dnsz.name
  virtual_network_id = azurerm_virtual_network.vnet.id
}

# Define Private Endpoint
resource "azurerm_private_endpoint" "pe" {
  name = local.pe_name
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id = azurerm_subnet.subnet_db.id

  private_service_connection {
    name = local.psc_name
    private_connection_resource_id = azurerm_postgresql_server.dbs.id
    subresource_names = var.psc_subresources
    is_manual_connection = var.psc_manual
  }

  private_dns_zone_group {
    name = var.dnszg_name
    private_dns_zone_ids = [ azurerm_private_dns_zone.dnsz.id ]
  }
}
