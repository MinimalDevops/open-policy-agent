package kubernetes.crd.helm_release

default allow = false

# Main policy rule
allow {
    # Check if chart is versioned
    has_versioned_chart(input.resource)
    
    # Check if valuesFrom is used
    uses_values_from(input.resource)
    
    # Check if release name follows convention
    follows_naming_convention(input.resource)
}

# Check if chart is versioned
has_versioned_chart(resource) {
    # Get chart reference
    chart := resource.spec.chart
    
    # Check if chart has version
    chart.version
    
    # Validate version format (semver)
    is_valid_semver(chart.version)
}

# Check if valuesFrom is used
uses_values_from(resource) {
    # Check if valuesFrom is present
    resource.spec.valuesFrom
    
    # Check if at least one valuesFrom source is configured
    count(resource.spec.valuesFrom) > 0
}

# Check if release name follows convention
follows_naming_convention(resource) {
    # Get release name
    name := resource.metadata.name
    
    # Check if name follows pattern: <team>-<env>-<app>
    regex.match("^[a-z]+-[a-z]+-[a-z0-9]+$", name)
}

# Validate semver format
is_valid_semver(version) {
    # Check if version follows semver pattern
    regex.match("^[0-9]+\\.[0-9]+\\.[0-9]+(-[0-9A-Za-z-]+(\\.[0-9A-Za-z-]+)*)?(\\+[0-9A-Za-z-]+(\\.[0-9A-Za-z-]+)*)?$", version)
}

# Violation messages
violation[{"msg": msg}] {
    not has_versioned_chart(input.resource)
    msg := "HelmRelease must use a versioned chart with valid semver"
}

violation[{"msg": msg}] {
    not uses_values_from(input.resource)
    msg := "HelmRelease must use valuesFrom for configuration"
}

violation[{"msg": msg}] {
    not follows_naming_convention(input.resource)
    msg := "HelmRelease name must follow pattern: <team>-<env>-<app>"
} 