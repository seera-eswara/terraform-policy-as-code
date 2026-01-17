data "terraform_remote_state" "landingzone" {
  backend = "azurerm"
  config = {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "tfstatelzqiaypb"
    container_name       = "tfstate"
    key                  = "landingzone.tfstate"
  }
}

resource "azurerm_policy_definition" "allowed_vm_skus" {
  name         = "allowed-vm-skus"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "Allowed VM SKUs"

  policy_rule = file("${path.module}/policies/definitions/allowed-vm-skus.json")
  parameters = jsonencode({
    allowedSkus = {
      type = "Array"
    }
  })
}
