package kubernetes.crd.argocd_application

default allow = false

# Main policy rule
allow {
    # Check if application follows naming convention
    follows_naming_convention(input.resource)
    
    # Check if application has required fields
    has_required_fields(input.resource)
    
    # Check if application has valid source
    has_valid_source(input.resource)
}

# Check if application follows naming convention
follows_naming_convention(resource) {
    # Get application name
    name := resource.metadata.name
    
    # Check if name follows pattern: <team>-<environment>-<app>
    regex.match("^[a-z]+-[a-z]+-[a-z]+$", name)
}

# Check if application has required fields
has_required_fields(resource) {
    # Check if project is set
    resource.spec.project
    
    # Check if destination is set
    resource.spec.destination
    
    # Check if source is set
    resource.spec.source
}

# Check if application has valid source
has_valid_source(resource) {
    # Get source
    source := resource.spec.source
    
    # Check if repoURL is set
    source.repoURL
    
    # Check if targetRevision is set
    source.targetRevision
    
    # Check if path is set
    source.path
}

# Violation messages
violation[{"msg": msg}] {
    not follows_naming_convention(input.resource)
    msg := "Application name must follow pattern: <team>-<environment>-<app>"
}

violation[{"msg": msg}] {
    not has_required_fields(input.resource)
    msg := "Application must have project, destination, and source fields"
}

violation[{"msg": msg}] {
    not has_valid_source(input.resource)
    msg := "Application source must have repoURL, targetRevision, and path fields"
} 