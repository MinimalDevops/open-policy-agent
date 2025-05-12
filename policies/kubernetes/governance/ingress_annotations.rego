package kubernetes.governance.ingress_annotations

default allow = false

# Required annotations
required_annotations = {
    "kubernetes.io/ingress.class",
    "nginx.ingress.kubernetes.io/ssl-redirect",
    "nginx.ingress.kubernetes.io/force-ssl-redirect"
}

# Main policy rule
allow {
    # Check if all required annotations are present
    has_required_annotations(input.resource)
    
    # Check if SSL redirect is enabled
    has_ssl_redirect(input.resource)
}

# Check if all required annotations are present
has_required_annotations(resource) {
    # Get all annotations
    annotations := resource.metadata.annotations
    
    # Check each required annotation
    required_annotations[annotation]
    annotations[annotation]
}

# Check if SSL redirect is enabled
has_ssl_redirect(resource) {
    # Get annotations
    annotations := resource.metadata.annotations
    
    # Check if SSL redirect is enabled
    annotations["nginx.ingress.kubernetes.io/ssl-redirect"] == "true"
    annotations["nginx.ingress.kubernetes.io/force-ssl-redirect"] == "true"
}

# Violation messages
violation[{"msg": msg}] {
    not has_required_annotations(input.resource)
    msg := "Ingress must have all required annotations"
}

violation[{"msg": msg}] {
    not has_ssl_redirect(input.resource)
    msg := "Ingress must have SSL redirect enabled"
} 