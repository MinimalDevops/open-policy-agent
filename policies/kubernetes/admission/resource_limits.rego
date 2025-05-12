package kubernetes.admission.resource_limits

import data.kubernetes.namespace

default allow = false

# Main policy rule
allow {
    # Check if resource has valid limits
    has_valid_limits(input.resource)
    
    # Check if resource has valid requests
    has_valid_requests(input.resource)
}

# Check if resource has valid limits
has_valid_limits(resource) {
    # Check CPU limits
    resource.spec.containers[_].resources.limits.cpu
    resource.spec.containers[_].resources.limits.memory
    
    # Validate CPU format
    is_valid_cpu_limit(resource.spec.containers[_].resources.limits.cpu)
    
    # Validate memory format
    is_valid_memory_limit(resource.spec.containers[_].resources.limits.memory)
}

# Check if resource has valid requests
has_valid_requests(resource) {
    # Check CPU requests
    resource.spec.containers[_].resources.requests.cpu
    resource.spec.containers[_].resources.requests.memory
    
    # Validate CPU format
    is_valid_cpu_request(resource.spec.containers[_].resources.requests.cpu)
    
    # Validate memory format
    is_valid_memory_request(resource.spec.containers[_].resources.requests.memory)
}

# Validate CPU limit format
is_valid_cpu_limit(cpu) {
    # Must be a valid CPU string (e.g., "500m", "1", "2")
    regex.match("^[0-9]+m?$", cpu)
}

# Validate memory limit format
is_valid_memory_limit(memory) {
    # Must be a valid memory string (e.g., "128Mi", "1Gi")
    regex.match("^[0-9]+[KMGTPEZYkmgtpezy]i?$", memory)
}

# Validate CPU request format
is_valid_cpu_request(cpu) {
    # Must be a valid CPU string
    regex.match("^[0-9]+m?$", cpu)
}

# Validate memory request format
is_valid_memory_request(memory) {
    # Must be a valid memory string
    regex.match("^[0-9]+[KMGTPEZYkmgtpezy]i?$", memory)
}

# Violation message
violation[{"msg": msg}] {
    not has_valid_limits(input.resource)
    msg := "Container must have CPU and memory limits specified"
}

violation[{"msg": msg}] {
    not has_valid_requests(input.resource)
    msg := "Container must have CPU and memory requests specified"
} 