package policy.tests

import data.policies.allowed_vm_skus
import data.policies.ai_exception

#############################
# Allowed VM SKU policy tests
#############################

test_allowed_skus_pass if {
  test_input := {
    "properties": {
      "parameters": {
        "allowedSkus": {
          "defaultValue": [
            "Standard_B2s",
            "Standard_D2s_v5"
          ]
        }
      }
    }
  }

  count(allowed_vm_skus.deny) == 0 with input as test_input
}

test_allowed_skus_fail_empty if {
  test_input := {
    "properties": {
      "parameters": {
        "allowedSkus": {
          "defaultValue": []
        }
      }
    }
  }

  count(allowed_vm_skus.deny) > 0 with input as test_input
}

#################################
# AI high-compute exception tests
#################################

test_ai_exception_allowed if {
  test_input := {
    "assignment_scope": "AI",
    "requested_sku": "Standard_NC24ads_A100_v4",
    "high_compute_skus": ["Standard_NC24ads_A100_v4"]
  }

  count(ai_exception.deny) == 0 with input as test_input
}

test_ai_exception_denied_for_corp if {
  test_input := {
    "assignment_scope": "Corp",
    "requested_sku": "Standard_NC24ads_A100_v4",
    "high_compute_skus": ["Standard_NC24ads_A100_v4"]
  }

  count(ai_exception.deny) > 0 with input as test_input
}
