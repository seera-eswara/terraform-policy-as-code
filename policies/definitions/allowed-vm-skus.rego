package policies.allowed_vm_skus

deny contains msg if {
  not input.properties.parameters.allowedSkus
  msg := "allowedSkus parameter must be defined"
}

deny contains msg if {
  count(input.properties.parameters.allowedSkus.defaultValue) == 0
  msg := "allowedSkus must not be empty"
}

deny contains msg if {
  sku := input.properties.parameters.allowedSkus.defaultValue[_]
  not startswith(sku, "Standard_")
  msg := sprintf("Invalid VM SKU format: %s", [sku])
}
