resource "azurerm_policy_assignment" "corp_allowed_skus" {
  name                 = "corp-allowed-vm-skus"
  policy_definition_id = azurerm_policy_definition.allowed_vm_skus.id
  scope                = data.terraform_remote_state.landingzone.outputs.corp_mg_id

  parameters = jsonencode({
    allowedSkus = {
      value = [
        "Standard_B2s",
        "Standard_B4ms",
        "Standard_D4s_v5",
        "Standard_D8s_v5"
      ]
    }
  })
}
