# Just-In-Time (JIT) Access Policies

This directory contains Open Policy Agent (OPA) policies for managing Just-In-Time access to resources. These policies enforce time-based access controls and temporary privilege elevation.

## Policies

### 1. Time-Based Access (`time_based_access.rego`)
Enforces time-based access controls:
- Maximum session duration
- Allowed access windows
- Timezone handling
- Session expiration

### 2. Privilege Elevation (`privilege_elevation.rego`)
Manages temporary privilege elevation:
- Maximum elevation duration
- Required approvals
- Scope of elevated access
- Audit logging requirements

## Usage

### Testing Policies

```bash
# Test time-based access policy
opa eval --input examples/time_based_access.json --data policies/jit "data.jit.time_based_access.allow"

# Test privilege elevation policy
opa eval --input examples/privilege_elevation.json --data policies/jit "data.jit.privilege_elevation.allow"
```

### Example Input

#### Time-Based Access
```json
{
    "request": {
        "user": "john.doe",
        "resource": "prod-database",
        "access_type": "read",
        "requested_duration": "2h",
        "timezone": "UTC"
    },
    "context": {
        "current_time": "2024-03-20T10:00:00Z",
        "allowed_hours": {
            "start": "09:00",
            "end": "17:00"
        }
    }
}
```

#### Privilege Elevation
```json
{
    "request": {
        "user": "john.doe",
        "role": "admin",
        "requested_duration": "1h",
        "reason": "emergency maintenance",
        "approvers": ["alice.smith", "bob.jones"]
    },
    "context": {
        "max_elevation_duration": "4h",
        "required_approvals": 2
    }
}
```

## Integration with OPA

To use these policies with OPA:

1. Load the policies into OPA:
```bash
opa run --server --addr :8181 policies/jit/
```

2. Query the policies:
```bash
curl -X POST http://localhost:8181/v1/data/jit/time_based_access/allow \
  -H "Content-Type: application/json" \
  -d @examples/time_based_access.json
```

## Policy Configuration

### Time-Based Access Settings
- Maximum session duration: 8 hours
- Allowed access windows: 09:00-17:00 UTC
- Required timezone specification
- Session expiration notification

### Privilege Elevation Settings
- Maximum elevation duration: 4 hours
- Minimum required approvals: 2
- Required reason documentation
- Audit log retention: 90 days

## Contributing

1. Fork the repository
2. Create a feature branch
3. Add your policy
4. Include tests and documentation
5. Submit a pull request 