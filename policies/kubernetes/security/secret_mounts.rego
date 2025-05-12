package kubernetes.security.secret_mounts

default allow = false

# Namespaces where secrets are allowed
allowed_secret_namespaces = {
    "kube-system",
    "cert-manager",
    "vault"
}

# Main policy rule
allow {
    # Check if no secrets are mounted in disallowed namespaces
    not has_secret_in_disallowed_namespace(input.resource)
}

# Check if secrets are mounted in disallowed namespaces
has_secret_in_disallowed_namespace(resource) {
    # Get namespace
    namespace := resource.metadata.namespace
    
    # Check if namespace is not allowed for secrets
    not allowed_secret_namespaces[namespace]
    
    # Check if any volume is a secret
    resource.spec.volumes[_].secret
} else {
    # Check if any volume mount references a secret
    resource.spec.containers[_].volumeMounts[_].name
    volume_name := resource.spec.containers[_].volumeMounts[_].name
    resource.spec.volumes[_].name == volume_name
    resource.spec.volumes[_].secret
}

# Violation message
violation[{"msg": msg}] {
    has_secret_in_disallowed_namespace(input.resource)
    msg := "Secrets can only be mounted in allowed namespaces: kube-system, cert-manager, vault"
} 