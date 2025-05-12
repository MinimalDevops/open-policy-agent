package kubernetes.crd.argocd_naming

default allow = false

# Allowed environments
allowed_environments = {
    "dev",
    "staging",
    "prod"
}

# Allowed teams
allowed_teams = {
    "platform",
    "backend",
    "frontend",
    "data"
}

# Main policy rule
allow {
    # Check if application follows naming convention
    follows_naming_convention(input.resource)
    
    # Check if components are valid
    has_valid_components(input.resource)
}

# Check if application follows naming convention
follows_naming_convention(resource) {
    # Get application name
    name := resource.metadata.name
    
    # Split name into components
    parts := split(name, "-")
    count(parts) == 3
    
    # Check each component
    team := parts[0]
    env := parts[1]
    app := parts[2]
    
    # Validate team
    allowed_teams[team]
    
    # Validate environment
    allowed_environments[env]
    
    # Validate app name (alphanumeric, lowercase)
    regex.match("^[a-z0-9]+$", app)
}

# Check if components are valid
has_valid_components(resource) {
    # Get name components
    name := resource.metadata.name
    parts := split(name, "-")
    
    # Check if team matches project
    team := parts[0]
    resource.spec.project == team
}

# Violation messages
violation[{"msg": msg}] {
    not follows_naming_convention(input.resource)
    msg := "Application name must follow pattern: <team>-<env>-<app> where team and env are from allowed lists"
}

violation[{"msg": msg}] {
    not has_valid_components(input.resource)
    msg := "Application project must match team name from application name"
} 