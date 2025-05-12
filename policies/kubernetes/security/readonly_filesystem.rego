package kubernetes.security.readonly_filesystem

default allow = false

# Main policy rule
allow {
    # Check if all containers have readOnlyRootFilesystem
    all_containers_readonly(input.resource)
}

# Check if all containers have readOnlyRootFilesystem
all_containers_readonly(resource) {
    # Get all containers
    container := resource.spec.containers[_]
    
    # Check if readOnlyRootFilesystem is true
    container.securityContext.readOnlyRootFilesystem == true
}

# Violation message
violation[{"msg": msg}] {
    not all_containers_readonly(input.resource)
    msg := "Container must have readOnlyRootFilesystem set to true"
} 