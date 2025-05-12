package kubernetes.crd.gitops_standards

default allow = false

# Main policy rule
allow {
    # Check if resource has required annotations
    has_required_annotations(input.resource)
    
    # Check if resource has required labels
    has_required_labels(input.resource)
    
    # Check if resource has valid source
    has_valid_source(input.resource)
}

# Required annotations
required_annotations = {
    "argocd.argoproj.io/sync-wave",
    "argocd.argoproj.io/sync-options",
    "argocd.argoproj.io/compare-options"
}

# Required labels
required_labels = {
    "app.kubernetes.io/name",
    "app.kubernetes.io/instance",
    "app.kubernetes.io/part-of"
}

# Check if resource has required annotations
has_required_annotations(resource) {
    # Get all annotations
    annotations := resource.metadata.annotations
    
    # Check each required annotation
    required_annotations[annotation]
    annotations[annotation]
}

# Check if resource has required labels
has_required_labels(resource) {
    # Get all labels
    labels := resource.metadata.labels
    
    # Check each required label
    required_labels[label]
    labels[label]
}

# Check if resource has valid source
has_valid_source(resource) {
    # Check if source is set
    resource.spec.source
    
    # Check if source has required fields
    source := resource.spec.source
    source.repoURL
    source.targetRevision
    source.path
}

# Violation messages
violation[{"msg": msg}] {
    not has_required_annotations(input.resource)
    msg := "Resource must have all required ArgoCD annotations"
}

violation[{"msg": msg}] {
    not has_required_labels(input.resource)
    msg := "Resource must have all required Kubernetes labels"
}

violation[{"msg": msg}] {
    not has_valid_source(input.resource)
    msg := "Resource must have valid source configuration"
} 