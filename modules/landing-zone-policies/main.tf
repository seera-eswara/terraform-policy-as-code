# Landing Zone Policy Module
# This module deploys Azure Policy definitions and assignments to Management Groups

# CloudInfra policy definitions
resource "azurerm_policy_definition" "allowed_vm_skus_cloudinfra" {
  name                = "cloudinfra-allowed-vm-skus"
  policy_type         = "Custom"
  mode                = "Indexed"
  display_name        = "Allowed VM SKUs"
  description         = "Restrict virtual machines to approved SKUs"
  management_group_id = var.cloudinfra_mg_id

  metadata = jsonencode({
    category = "Compute"
    version  = "1.0.0"
  })

  policy_rule = jsonencode({
    if = {
      allOf = [
        {
          field  = "type"
          equals = "Microsoft.Compute/virtualMachines"
        },
        {
          not = {
            field = "Microsoft.Compute/virtualMachines/sku.name"
            in    = "[parameters('allowedSkus')]"
          }
        }
      ]
    }
    then = {
      effect = "Deny"
    }
  })

  parameters = jsonencode({
    allowedSkus = {
      type = "Array"
      metadata = {
        description = "List of permitted VM sizes"
        displayName = "Allowed VM SKUs"
      }
    }
  })
}

resource "azurerm_policy_definition" "naming_convention_cloudinfra" {
  name                = "cloudinfra-naming-convention"
  policy_type         = "Custom"
  mode                = "Indexed"
  display_name        = "Resource Naming Convention"
  description         = "Enforce standardized resource naming patterns"
  management_group_id = var.cloudinfra_mg_id

  metadata = jsonencode({
    category = "Naming"
    version  = "1.0.0"
  })

  policy_rule = jsonencode({
    if = {
      allOf = [
        {
          field = "type"
          in    = [
            "Microsoft.Compute/virtualMachines",
            "Microsoft.Storage/storageAccounts",
            "Microsoft.Network/virtualNetworks",
            "Microsoft.ContainerService/managedClusters",
          ]
        },
        {
          not = {
            field = "name"
            match = "[parameters('namingPattern')]"
          }
        }
      ]
    }
    then = {
      effect = "deny"
    }
  })

  parameters = jsonencode({
    namingPattern = {
      type = "String"
      metadata = {
        description = "Regex pattern for resource naming (e.g., app-env-resource)"
        displayName = "Naming Pattern"
      }
    }
  })
}

# LandingZones policy definitions
resource "azurerm_policy_definition" "allowed_vm_skus_lz" {
  name = "lz-allowed-skus"
  policy_type         = "Custom"
  mode                = "Indexed"
  display_name        = "Allowed VM SKUs"
  description         = "Restrict virtual machines to approved SKUs"
  management_group_id = var.landingzone_mg_id

  metadata = jsonencode({
    category = "Compute"
    version  = "1.0.0"
  })

  policy_rule = jsonencode({
    if = {
      allOf = [
        {
          field  = "type"
          equals = "Microsoft.Compute/virtualMachines"
        },
        {
          not = {
            field = "Microsoft.Compute/virtualMachines/sku.name"
            in    = "[parameters('allowedSkus')]"
          }
        }
      ]
    }
    then = {
      effect = "Deny"
    }
  })

  parameters = jsonencode({
    allowedSkus = {
      type = "Array"
      metadata = {
        description = "List of permitted VM sizes"
        displayName = "Allowed VM SKUs"
      }
    }
  })
}

resource "azurerm_policy_definition" "naming_convention_lz" {
  name = "lz-naming"
  policy_type         = "Custom"
  mode                = "Indexed"
  display_name        = "Resource Naming Convention"
  description         = "Enforce standardized resource naming patterns"
  management_group_id = var.landingzone_mg_id

  metadata = jsonencode({
    category = "Naming"
    version  = "1.0.0"
  })

  policy_rule = jsonencode({
    if = {
      allOf = [
        {
          field = "type"
          in    = [
            "Microsoft.Compute/virtualMachines",
            "Microsoft.Storage/storageAccounts",
            "Microsoft.Network/virtualNetworks",
            "Microsoft.ContainerService/managedClusters",
          ]
        },
        {
          not = {
            field = "name"
            match = "[parameters('namingPattern')]"
          }
        }
      ]
    }
    then = {
      effect = "deny"
    }
  })

  parameters = jsonencode({
    namingPattern = {
      type = "String"
      metadata = {
        description = "Regex pattern for resource naming (e.g., app-env-resource)"
        displayName = "Naming Pattern"
      }
    }
  })
}

# Policy Assignments for cloudinfra MG
resource "azurerm_management_group_policy_assignment" "cloudinfra_allowed_skus" {
  count = var.enable_cloudinfra_policies ? 1 : 0

  name                 = "ci-allowed-skus"
  policy_definition_id = azurerm_policy_definition.allowed_vm_skus_cloudinfra.id
  management_group_id  = var.cloudinfra_mg_id

  parameters = jsonencode({
    allowedSkus = {
      value = var.cloudinfra_allowed_vm_skus
    }
  })

  description  = "Enforce allowed VM SKUs across cloudinfra subscriptions"
  display_name = "cloudinfra: Allowed VM SKUs"
}

resource "azurerm_management_group_policy_assignment" "cloudinfra_naming" {
  count = var.enable_cloudinfra_policies ? 1 : 0

  name                 = "ci-naming"
  policy_definition_id = azurerm_policy_definition.naming_convention_cloudinfra.id
  management_group_id  = var.cloudinfra_mg_id

  parameters = jsonencode({
    namingPattern = {
      value = var.naming_pattern
    }
  })

  description  = "Enforce resource naming conventions"
  display_name = "cloudinfra: Naming Convention"
}

# Policy Assignments for LandingZones MG
resource "azurerm_management_group_policy_assignment" "landingzone_allowed_skus" {
  count = var.enable_landingzone_policies ? 1 : 0

  name                 = "lz-allowed-skus"
  policy_definition_id = azurerm_policy_definition.allowed_vm_skus_lz.id
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

  name                 = "lz-naming"
  policy_definition_id = azurerm_policy_definition.naming_convention_lz.id
  management_group_id  = var.landingzone_mg_id

  parameters = jsonencode({
    namingPattern = {
      value = var.naming_pattern
    }
  })

  description  = "Enforce resource naming conventions for app subscriptions"
  display_name = "LandingZones: Naming Convention"
}
