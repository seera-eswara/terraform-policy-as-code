variable "exemptions" {
  description = "List of policy exemptions to create"
  type = list(object({
    name                  = string
    display_name          = optional(string)
    description           = optional(string)
    scope                 = optional(string)       # ARM scope: /providers/Microsoft.Management/managementGroups/..., /subscriptions/..., /subscriptions/.../resourceGroups/..., or full resource ID
    app_code              = optional(string)       # If provided, scope is resolved via app_scopes map
    policy_assignment_id  = string                 # ID of the policy assignment to exempt from
    exemption_category    = string                 # Waiver or Mitigated
    expires_on            = optional(string)       # RFC3339 timestamp e.g., 2026-12-31T23:59:59Z
    metadata              = optional(map(string))  # Additional context fields
  }))
  default = []
}

variable "app_scopes" {
  description = "Map of app_code to ARM scopes (subscription/resource group/resource IDs)"
  type        = map(string)
  default     = {}
}

variable "emit_report_path" {
  description = "If set, emits a JSON report of exemptions to this file path"
  type        = string
  default     = ""
}
