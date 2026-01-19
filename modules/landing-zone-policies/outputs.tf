output "policy_definition_ids" {
  description = "IDs of created policy definitions"
  value = {
    allowed_vm_skus    = azurerm_policy_definition.allowed_vm_skus.id
    naming_convention  = azurerm_policy_definition.naming_convention.id
  }
}

output "platform_policy_assignments" {
  description = "IDs of policy assignments for Platform MG"
  value = {
    allowed_vm_skus = var.enable_platform_policies ? azurerm_management_group_policy_assignment.platform_allowed_skus[0].id : null
    naming          = var.enable_platform_policies ? azurerm_management_group_policy_assignment.platform_naming[0].id : null
  }
}

output "landingzone_policy_assignments" {
  description = "IDs of policy assignments for LandingZones MG"
  value = {
    allowed_vm_skus = var.enable_landingzone_policies ? azurerm_management_group_policy_assignment.landingzone_allowed_skus[0].id : null
    naming          = var.enable_landingzone_policies ? azurerm_management_group_policy_assignment.landingzone_naming[0].id : null
  }
}
