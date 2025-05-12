package kubernetes.admission.image_registry

default allow = false

# Allowed registries
allowed_registries = {
    "docker.io/",
    "gcr.io/",
    "quay.io/",
    "602401143452.dkr.ecr.us-west-2.amazonaws.com/",
    "602401143452.dkr.ecr.us-east-1.amazonaws.com/"
}

# Main policy rule
allow {
    # Check if all container images are from allowed registries
    all_images_from_allowed_registry(input.resource)
}

# Check if all container images are from allowed registries
all_images_from_allowed_registry(resource) {
    # Get all container images
    image := resource.spec.containers[_].image
    
    # Check if image is from allowed registry
    is_from_allowed_registry(image)
}

# Check if image is from allowed registry
is_from_allowed_registry(image) {
    # Check if image starts with any allowed registry
    startswith(image, allowed_registries[_])
}

# Violation message
violation[{"msg": msg}] {
    not all_images_from_allowed_registry(input.resource)
    msg := "Container image must be from an allowed registry"
} 