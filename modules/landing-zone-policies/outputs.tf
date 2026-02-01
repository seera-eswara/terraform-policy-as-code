output "policy_definition_ids" {
  description = "IDs of created policy definitions"
  value = {
    platform_allowed_vm_skus    = azurerm_policy_definition.allowed_vm_skus_platform.id
    platform_naming_convention  = azurerm_policy_definition.naming_convention_platform.id
    lz_allowed_vm_skus            = azurerm_policy_definition.allowed_vm_skus_lz.id
    lz_naming_convention          = azurerm_policy_definition.naming_convention_lz.id
  }
}

output "platform_policy_assignments" {
  description = "IDs of policy assignments for platform MG"
  value = {
    allowed_vm_skus = try(one(azurerm_management_group_policy_assignment.platform_allowed_skus[*].id), null)
    naming          = try(one(azurerm_management_group_policy_assignment.platform_naming[*].id), null)
  }
}

output "landingzone_policy_assignments" {
  description = "IDs of policy assignments for LandingZones MG"
  value = {
    allowed_vm_skus = try(one(azurerm_management_group_policy_assignment.landingzone_allowed_skus[*].id), null)
    naming          = try(one(azurerm_management_group_policy_assignment.landingzone_naming[*].id), null)
  }
}
