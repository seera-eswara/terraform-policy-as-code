# Policy Exemptions Module
# Creates Azure Policy exemptions at MG, subscription, RG, or resource scope

locals {
  exemptions_map = { for ex in var.exemptions : ex.name => ex }
  exemptions_report = [
    for ex in var.exemptions : {
      name                 = ex.name
      app_code             = try(ex.app_code, null)
      scope                = coalesce(try(ex.scope, null), lookup(var.app_scopes, try(ex.app_code, ""), null))
      policy_assignment_id = ex.policy_assignment_id
      exemption_category   = ex.exemption_category
      expires_on           = try(ex.expires_on, null)
      id                   = try(azurerm_policy_exemption.this[ex.name].id, null)
      metadata             = coalesce(try(ex.metadata, {}), {})
    }
  ]
}

resource "azurerm_policy_exemption" "this" {
  for_each = local.exemptions_map

  name                 = each.value.name
  display_name         = coalesce(each.value.display_name, each.value.name)
  description          = each.value.description
  exemption_category   = each.value.exemption_category
  expires_on           = each.value.expires_on

  # Scope can be any ARM scope: management group, subscription, RG, or resource
  # Resolve by explicit scope or app_code -> var.app_scopes map
  scope                = coalesce(each.value.scope, lookup(var.app_scopes, try(each.value.app_code, ""), null))

  policy_assignment_id = each.value.policy_assignment_id

  metadata = jsonencode(coalesce(each.value.metadata, {}))

  lifecycle {
    ignore_changes = [metadata]
  }
}

# Optional: emit JSON report to a file for audit/filtering by app_code
resource "local_file" "exemptions_report" {
  count    = var.emit_report_path != "" ? 1 : 0
  content  = jsonencode(local.exemptions_report)
  filename = var.emit_report_path
}
