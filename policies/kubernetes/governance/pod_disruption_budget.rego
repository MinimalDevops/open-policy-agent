package kubernetes.governance.pod_disruption_budget

import data.kubernetes.deployments
import data.kubernetes.poddisruptionbudgets

default allow = false

# Main policy rule
allow {
    # Check if deployment has PodDisruptionBudget
    has_pod_disruption_budget(input.deployment)
}

# Check if deployment has PodDisruptionBudget
has_pod_disruption_budget(deployment) {
    # Get deployment namespace
    namespace := deployment.metadata.namespace
    
    # Get deployment name
    name := deployment.metadata.name
    
    # Get all PodDisruptionBudgets in the namespace
    budgets := poddisruptionbudgets.list(namespace)
    
    # Check if any budget matches the deployment
    some budget in budgets
    budget.spec.selector.matchLabels == deployment.spec.selector.matchLabels
}

# Violation message
violation[{"msg": msg}] {
    not has_pod_disruption_budget(input.deployment)
    msg := "Deployment must have a PodDisruptionBudget"
} 