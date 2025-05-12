package kubernetes.security.host_access

default allow = false

# Main policy rule
allow {
    # Check if hostNetwork is not enabled
    not has_host_network(input.resource)
    
    # Check if hostPID is not enabled
    not has_host_pid(input.resource)
}

# Check if hostNetwork is enabled
has_host_network(resource) {
    resource.spec.hostNetwork == true
}

# Check if hostPID is enabled
has_host_pid(resource) {
    resource.spec.hostPID == true
}

# Violation messages
violation[{"msg": msg}] {
    has_host_network(input.resource)
    msg := "Pod must not use hostNetwork"
}

violation[{"msg": msg}] {
    has_host_pid(input.resource)
    msg := "Pod must not use hostPID"
} 