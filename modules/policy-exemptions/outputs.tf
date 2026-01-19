output "exemption_ids" {
  description = "Map of exemption names to IDs"
  value       = { for k, v in azurerm_policy_exemption.this : k => v.id }
}

output "exemptions_report" {
  description = "List of exemptions with app_code, scope, IDs, and metadata for filtering"
  value       = local.exemptions_report
}
