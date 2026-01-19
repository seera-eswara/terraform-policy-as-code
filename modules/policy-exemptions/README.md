# Policy Exemptions Module

Create Azure Policy exemptions at any ARM scope (management group, subscription, resource group, resource).

## Usage

```hcl
module "policy_exemptions" {
  source = "git::https://github.com/seera-eswara/terraform-policy-as-code.git//modules/policy-exemptions?ref=v1.2.0"

  # Map app codes to scopes (subscription/resource group/resource IDs)
  app_scopes = {
    app1 = azurerm_subscription.app1.id
    app2 = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-app2-prod"
  }

  exemptions = [
    {
      name                 = "app1-legacy-vm-exemption"
      display_name         = "App1 Legacy VM SKU Exception"
      description          = "App1 requires Standard_E4s_v3 for legacy DB; approved by Security."
      app_code             = "app1"  # scope resolved via app_scopes
      policy_assignment_id = module.landing_zone_policies.landingzone_policy_assignments.allowed_vm_skus
      exemption_category   = "Waiver"   # or "Mitigated"
      expires_on           = "2026-12-31T23:59:59Z"
      metadata = {
        requestedBy = "app1-team@company.com"
        approvedBy  = "security-team@company.com"
        ticketId    = "SEC-12345"
      }
    }
  ]
  
  # Optional: emit a JSON report for auditing/filtering
  emit_report_path = "exemptions-report.json"
}
```

## Notes
- `scope` accepts any ARM scope ID.
- Use `"Waiver"` for full exception, `"Mitigated"` when compensating controls exist.
- Prefer time-bound `expires_on` values to avoid indefinite exemptions.
- `metadata` is free-form; include approver, ticket, and justification.
- Use `app_code` with `app_scopes` to target by application without hardcoding scope IDs.

## Filter by app_code

- Terraform outputs:

```bash
terraform output -json policy_exemptions_exemptions_report | jq '.[] | select(.app_code=="app1")'
```

- If `emit_report_path` is set:

```bash
jq '.[] | select(.app_code=="app1")' exemptions-report.json
```
