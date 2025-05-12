package kubernetes.governance.replica_limits

default allow = false

# Maximum replicas for staging
max_staging_replicas = 3

# Main policy rule
allow {
    # Check if replicas are within limits
    replicas_within_limits(input.resource)
}

# Check if replicas are within limits
replicas_within_limits(resource) {
    # Get environment from labels
    environment := resource.metadata.labels.environment
    
    # If not staging, allow any number of replicas
    environment != "staging"
} else {
    # For staging, check replica count
    resource.spec.replicas <= max_staging_replicas
}

# Violation message
violation[{"msg": msg}] {
    not replicas_within_limits(input.resource)
    msg := sprintf("Staging deployments cannot have more than %d replicas", [max_staging_replicas])
} 