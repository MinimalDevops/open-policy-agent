package kubernetes.audit.audit_mode

import data.kubernetes.violations

default allow = true

# Main policy rule for audit mode
audit {
    # Get all violations
    violations := get_all_violations()
    
    # Check if there are any violations
    count(violations) > 0
}

# Get all violations
get_all_violations() = violations {
    # Get violations from all policies
    violations := violations.list()
}

# Violation message
violation[{"msg": msg}] {
    # Get all violations
    violations := get_all_violations()
    
    # Check if there are any violations
    count(violations) > 0
    
    # Create message
    msg := sprintf("Found %d policy violations in audit mode", [count(violations)])
}

# Dry run mode
dry_run {
    # Get all violations
    violations := get_all_violations()
    
    # Check if there are any violations
    count(violations) > 0
    
    # Create dry run report
    dry_run_report(violations)
}

# Create dry run report
dry_run_report(violations) {
    # Get violation details
    violation := violations[_]
    
    # Create report entry
    report[{"resource": violation.resource, "policy": violation.policy, "message": violation.message}]
} 