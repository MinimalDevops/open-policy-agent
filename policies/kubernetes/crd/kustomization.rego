package kubernetes.crd.kustomization

default allow = false

# Main policy rule
allow {
    # Check if kustomization follows naming convention
    follows_naming_convention(input.resource)
    
    # Check if kustomization has required fields
    has_required_fields(input.resource)
    
    # Check if kustomization uses proper structure
    has_proper_structure(input.resource)
}

# Check if kustomization follows naming convention
follows_naming_convention(resource) {
    # Get kustomization name
    name := resource.metadata.name
    
    # Check if name follows pattern: <team>-<env>-<app>
    regex.match("^[a-z]+-[a-z]+-[a-z0-9]+$", name)
}

# Check if kustomization has required fields
has_required_fields(resource) {
    # Check if path is set
    resource.spec.path
    
    # Check if targetNamespace is set
    resource.spec.targetNamespace
    
    # Check if sourceRef is set
    resource.spec.sourceRef
}

# Check if kustomization uses proper structure
has_proper_structure(resource) {
    # Get path
    path := resource.spec.path
    
    # Check if path contains required files
    has_kustomization_yaml(path)
    has_kustomization_config(path)
}

# Check if path contains kustomization.yaml
has_kustomization_yaml(path) {
    # This would typically check if the file exists
    # In OPA, we can only check the path structure
    regex.match(".*/kustomization\\.yaml$", path)
}

# Check if path contains kustomization config
has_kustomization_config(path) {
    # Check if path contains config directory
    regex.match(".*/config/.*", path)
}

# Violation messages
violation[{"msg": msg}] {
    not follows_naming_convention(input.resource)
    msg := "Kustomization name must follow pattern: <team>-<env>-<app>"
}

violation[{"msg": msg}] {
    not has_required_fields(input.resource)
    msg := "Kustomization must have path, targetNamespace, and sourceRef fields"
}

violation[{"msg": msg}] {
    not has_proper_structure(input.resource)
    msg := "Kustomization must have proper directory structure with kustomization.yaml and config"
} 