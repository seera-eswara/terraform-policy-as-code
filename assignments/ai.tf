resource "azurerm_policy_assignment" "ai_allowed_skus" {
  name                 = "ai-allowed-vm-skus"
  policy_definition_id = azurerm_policy_definition.allowed_vm_skus.id
  scope                = data.terraform_remote_state.landingzone.outputs.ai_mg_id

  parameters = jsonencode({
    allowedSkus = {
      value = [
        "Standard_B2s",
        "Standard_D4s_v5",
        "Standard_NC6",
        "Standard_NC12",
        "Standard_ND40rs_v2"
      ]
    }
  })
}
