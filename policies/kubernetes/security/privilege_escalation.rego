package kubernetes.security.privilege_escalation

default allow = false

# Main policy rule
allow {
    # Check if no container allows privilege escalation
    not has_privilege_escalation(input.resource)
}

# Check if any container allows privilege escalation
has_privilege_escalation(resource) {
    # Check if allowPrivilegeEscalation is true
    resource.spec.containers[_].securityContext.allowPrivilegeEscalation == true
} else {
    # Check if securityContext is not set (defaults to true)
    not resource.spec.containers[_].securityContext
}

# Violation message
violation[{"msg": msg}] {
    has_privilege_escalation(input.resource)
    msg := "Container must not allow privilege escalation"
} 