package kubernetes.admission.root_containers

default allow = false

# Main policy rule
allow {
    # Check if no container runs as root
    not has_root_container(input.resource)
}

# Check if any container runs as root
has_root_container(resource) {
    # Check runAsUser
    resource.spec.containers[_].securityContext.runAsUser == 0
} else {
    # Check if securityContext is not set (defaults to root)
    not resource.spec.containers[_].securityContext
}

# Violation message
violation[{"msg": msg}] {
    has_root_container(input.resource)
    msg := "Container must not run as root (runAsUser: 0)"
} 