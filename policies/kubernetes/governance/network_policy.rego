package kubernetes.governance.network_policy

import data.kubernetes.networkpolicies

default allow = false

# Main policy rule
allow {
    # Check if namespace has NetworkPolicy
    has_network_policy(input.namespace)
}

# Check if namespace has NetworkPolicy
has_network_policy(namespace) {
    # Get all NetworkPolicies in the namespace
    policies := networkpolicies.list(namespace)
    
    # Check if there is at least one policy
    count(policies) > 0
}

# Violation message
violation[{"msg": msg}] {
    not has_network_policy(input.namespace)
    msg := "Namespace must have at least one NetworkPolicy"
} 