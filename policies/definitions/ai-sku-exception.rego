package policies.ai_exception

deny contains msg if {
  input.assignment_scope != "AI"
  sku := input.requested_sku
  sku in input.high_compute_skus
  msg := sprintf("High compute SKU %s is only allowed for AI workloads", [sku])
}
