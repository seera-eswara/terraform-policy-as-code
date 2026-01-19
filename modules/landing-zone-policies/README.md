# Landing Zone Policy Module

Deploys Azure Policy definitions and assignments to Management Groups.

## Usage

```hcl
module "landing_zone_policies" {
  source = "git::https://github.com/seera-eswara/terraform-policy-as-code.git//modules/landing-zone-policies?ref=v1.0.0"

  platform_mg_id    = azurerm_management_group.platform.id
  landingzone_mg_id = azurerm_management_group.landingzones.id

  platform_allowed_vm_skus = [
    "Standard_D4s_v3",
    "Standard_D8s_v3"
  ]

  landingzone_allowed_vm_skus = [
    "Standard_D2s_v3",
    "Standard_D4s_v3"
  ]
}
```

## What It Does

1. Creates policy definitions in Azure
2. Assigns policies to Platform MG
3. Assigns policies to LandingZones MG
4. Policies cascade to child subscriptions

## Policies Included

- **Allowed VM SKUs**: Restricts VM sizes
- **Naming Convention**: Enforces resource naming patterns

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| platform_mg_id | Management Group ID for Platform | string | "" |
| landingzone_mg_id | Management Group ID for LandingZones | string | "" |
| enable_platform_policies | Enable policies for Platform | bool | true |
| enable_landingzone_policies | Enable policies for LandingZones | bool | true |
| platform_allowed_vm_skus | Allowed VM SKUs for Platform | list(string) | See variables.tf |
| landingzone_allowed_vm_skus | Allowed VM SKUs for LandingZones | list(string) | See variables.tf |
| naming_pattern | Regex for resource naming | string | "^[a-z]+-[a-z]+-[a-z]+..." |
| environments | Allowed environments | list(string) | ["dev", "stage", "prod"] |

## Outputs

| Name | Description |
|------|-------------|
| policy_definition_ids | IDs of created policy definitions |
| platform_policy_assignments | Policy assignments for Platform MG |
| landingzone_policy_assignments | Policy assignments for LandingZones MG |
