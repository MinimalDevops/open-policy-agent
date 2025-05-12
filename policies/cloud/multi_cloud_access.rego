package cloud.access

import data.cloud.aws
import data.cloud.azure
import data.cloud.gcp

default allow = false

# Main policy for multi-cloud access control
allow {
    # Check if user has required role
    has_required_role(input.user, input.cloud_provider)
    
    # Check if action is allowed for the role
    is_action_allowed(input.action, input.cloud_provider)
    
    # Check if resource is accessible
    is_resource_accessible(input.resource, input.cloud_provider)
}

# Check if user has required role
has_required_role(user, provider) {
    roles := get_user_roles(user)
    required_role := get_required_role(provider)
    roles[required_role]
}

# Get user roles (example implementation)
get_user_roles(user) = roles {
    user_roles[user] = roles
}

# Get required role for provider
get_required_role(provider) = role {
    provider_roles[provider] = role
}

# Check if action is allowed
is_action_allowed(action, provider) {
    allowed_actions[provider][action]
}

# Check if resource is accessible
is_resource_accessible(resource, provider) {
    allowed_resources[provider][resource]
}

# Example user roles
user_roles = {
    "user1": {"admin", "developer"},
    "user2": {"viewer"}
}

# Required roles per provider
provider_roles = {
    "aws": "admin",
    "azure": "contributor",
    "gcp": "owner"
}

# Allowed actions per provider
allowed_actions = {
    "aws": {
        "ec2:StartInstances",
        "ec2:StopInstances",
        "s3:GetObject"
    },
    "azure": {
        "Microsoft.Compute/virtualMachines/start/action",
        "Microsoft.Compute/virtualMachines/deallocate/action"
    },
    "gcp": {
        "compute.instances.start",
        "compute.instances.stop"
    }
}

# Allowed resources per provider
allowed_resources = {
    "aws": {
        "arn:aws:ec2:*:*:instance/*",
        "arn:aws:s3:::my-bucket/*"
    },
    "azure": {
        "/subscriptions/*/resourceGroups/*/providers/Microsoft.Compute/virtualMachines/*"
    },
    "gcp": {
        "projects/*/zones/*/instances/*"
    }
} 