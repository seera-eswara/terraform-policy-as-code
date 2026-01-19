# Landing Zone Policy Module
# This module deploys Azure Policy definitions and assignments
# to Management Groups

# Create policy definitions
resource "azurerm_policy_definition" "allowed_vm_skus" {
  name         = "allowed-vm-skus"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "Allowed VM SKUs"
  description  = "Restrict virtual machines to approved SKUs"

  metadata = jsonencode({
    category = "Compute"
    version  = "1.0.0"
  })

  policy_rule = file("${path.module}/../../policies/definitions/allowed-vm-skus.json")
}

resource "azurerm_policy_definition" "naming_convention" {
  name         = "naming-convention"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "Resource Naming Convention"
  description  = "Enforce standardized resource naming patterns"

  metadata = jsonencode({
    category = "Naming"
    version  = "1.0.0"
  })

  policy_rule = file("${path.module}/../../policies/definitions/naming-convention.json")
}

# Policy Assignments for Platform MG
resource "azurerm_management_group_policy_assignment" "platform_allowed_skus" {
  count = var.enable_platform_policies ? 1 : 0

  name                 = "platform-allowed-vm-skus"
  policy_definition_id = azurerm_policy_definition.allowed_vm_skus.id
  management_group_id  = var.platform_mg_id

  parameters = jsonencode({
    allowedSkus = {
      value = var.platform_allowed_vm_skus
    }
  })

  description  = "Enforce allowed VM SKUs across Platform subscriptions"
  display_name = "Platform: Allowed VM SKUs"
}

resource "azurerm_management_group_policy_assignment" "platform_naming" {
  count = var.enable_platform_policies ? 1 : 0

  name                 = "platform-naming-convention"
  policy_definition_id = azurerm_policy_definition.naming_convention.id
  management_group_id  = var.platform_mg_id

  parameters = jsonencode({
    namingPattern = {
      value = var.naming_pattern
    }
    environment = {
      value = var.environments
    }
  })

  description  = "Enforce resource naming conventions"
  display_name = "Platform: Naming Convention"
}

# Policy Assignments for LandingZones MG
resource "azurerm_management_group_policy_assignment" "landingzone_allowed_skus" {
  count = var.enable_landingzone_policies ? 1 : 0

  name                 = "landingzone-allowed-vm-skus"
  policy_definition_id = azurerm_policy_definition.allowed_vm_skus.id
  management_group_id  = var.landingzone_mg_id

  parameters = jsonencode({
    allowedSkus = {
      value = var.landingzone_allowed_vm_skus
    }
  })

  description  = "Enforce allowed VM SKUs across App Team subscriptions"
  display_name = "LandingZones: Allowed VM SKUs"
}

resource "azurerm_management_group_policy_assignment" "landingzone_naming" {
  count = var.enable_landingzone_policies ? 1 : 0

  name                 = "landingzone-naming-convention"
  policy_definition_id = azurerm_policy_definition.naming_convention.id
  management_group_id  = var.landingzone_mg_id

  parameters = jsonencode({
    namingPattern = {
      value = var.naming_pattern
    }
    environment = {
      value = var.environments
    }
  })

  description  = "Enforce resource naming conventions for app subscriptions"
  display_name = "LandingZones: Naming Convention"
}
