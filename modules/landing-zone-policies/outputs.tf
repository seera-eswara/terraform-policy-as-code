output "policy_definition_ids" {
  description = "IDs of created policy definitions"
  value = {
    cloudinfra_allowed_vm_skus    = azurerm_policy_definition.allowed_vm_skus_cloudinfra.id
    cloudinfra_naming_convention  = azurerm_policy_definition.naming_convention_cloudinfra.id
    lz_allowed_vm_skus            = azurerm_policy_definition.allowed_vm_skus_lz.id
    lz_naming_convention          = azurerm_policy_definition.naming_convention_lz.id
  }
}

output "cloudinfra_policy_assignments" {
  description = "IDs of policy assignments for cloudinfra MG"
  value = {
    allowed_vm_skus = var.enable_cloudinfra_policies ? azurerm_management_group_policy_assignment.cloudinfra_allowed_skus[0].id : null
    naming          = var.enable_cloudinfra_policies ? azurerm_management_group_policy_assignment.cloudinfra_naming[0].id : null
  }
}

output "landingzone_policy_assignments" {
  description = "IDs of policy assignments for LandingZones MG"
  value = {
    allowed_vm_skus = var.enable_landingzone_policies ? azurerm_management_group_policy_assignment.landingzone_allowed_skus[0].id : null
    naming          = var.enable_landingzone_policies ? azurerm_management_group_policy_assignment.landingzone_naming[0].id : null
  }
}
