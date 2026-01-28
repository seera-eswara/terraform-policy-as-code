variable "cloudinfra_mg_id" {
  description = "Management Group ID for cloudinfra"
  type        = string
  default     = ""
}

variable "landingzone_mg_id" {
  description = "Management Group ID for LandingZones"
  type        = string
  default     = ""
}

variable "enable_cloudinfra_policies" {
  description = "Enable policy assignments for cloudinfra MG"
  type        = bool
  default     = true
}

variable "enable_landingzone_policies" {
  description = "Enable policy assignments for LandingZones MG"
  type        = bool
  default     = true
}

variable "cloudinfra_allowed_vm_skus" {
  description = "Allowed VM SKUs for cloudinfra subscriptions"
  type        = list(string)
  default = [
    "Standard_B2ts_v2",
    "Standard_D2s_v3",
    "Standard_D4s_v3",
    "Standard_B4ms"
  ]
}

variable "landingzone_allowed_vm_skus" {
  description = "Allowed VM SKUs for LandingZone subscriptions"
  type        = list(string)
  default = [
    "Standard_B2ts_v2",
    "Standard_D2s_v3",
    "Standard_D4s_v3",
    "Standard_B4ms",
    "Standard_F2s_v2"
  ]
}

variable "naming_pattern" {
  description = "Regex pattern for resource naming"
  type        = string
  default     = "^[a-z]+-[a-z]+-[a-z]+(-[a-z0-9]+)?$"
}

variable "environments" {
  description = "Allowed environment values"
  type        = list(string)
  default     = ["dev", "stage", "prod"]
}
