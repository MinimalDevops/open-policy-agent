package kubernetes.admission.labels_annotations

default allow = false

# Required labels
required_labels = {
    "cost-center",
    "team",
    "environment"
}

# Required annotations
required_annotations = {
    "owner",
    "managed-by"
}

# Main policy rule
allow {
    # Check if all required labels are present
    has_required_labels(input.resource)
    
    # Check if all required annotations are present
    has_required_annotations(input.resource)
}

# Check if resource has all required labels
has_required_labels(resource) {
    # Get all labels
    labels := resource.metadata.labels
    
    # Check each required label
    required_labels[label]
    labels[label]
}

# Check if resource has all required annotations
has_required_annotations(resource) {
    # Get all annotations
    annotations := resource.metadata.annotations
    
    # Check each required annotation
    required_annotations[annotation]
    annotations[annotation]
}

# Violation messages
violation[{"msg": msg}] {
    not has_required_labels(input.resource)
    msg := "Resource must have all required labels: cost-center, team, environment"
}

violation[{"msg": msg}] {
    not has_required_annotations(input.resource)
    msg := "Resource must have all required annotations: owner, managed-by"
} 