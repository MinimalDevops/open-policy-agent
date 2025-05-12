# Geolocation Policies

This directory contains Open Policy Agent (OPA) policies for enforcing geolocation-based access controls and data residency requirements.

## Policies

### 1. Access Control (`access_control.rego`)
Enforces geolocation-based access restrictions:
- Allowed countries/regions
- IP-based geolocation validation
- VPN detection
- Access time restrictions by region

### 2. Data Residency (`data_residency.rego`)
Enforces data residency requirements:
- Data storage location validation
- Cross-border data transfer rules
- Regional compliance requirements
- Data sovereignty checks

## Usage

### Testing Policies

```bash
# Test access control policy
opa eval --input examples/access_control.json --data policies/geolocation "data.geolocation.access_control.allow"

# Test data residency policy
opa eval --input examples/data_residency.json --data policies/geolocation "data.geolocation.data_residency.allow"
```

### Example Input

#### Access Control
```json
{
    "request": {
        "user": "john.doe",
        "ip_address": "192.168.1.1",
        "timestamp": "2024-03-20T10:00:00Z",
        "resource": "sensitive-data"
    },
    "context": {
        "allowed_countries": ["US", "CA", "UK"],
        "restricted_hours": {
            "US": {"start": "09:00", "end": "17:00"},
            "UK": {"start": "09:00", "end": "17:00"}
        }
    }
}
```

#### Data Residency
```json
{
    "request": {
        "data_type": "personal",
        "storage_location": "eu-west-1",
        "transfer_destination": "us-east-1",
        "compliance_requirements": ["GDPR", "CCPA"]
    },
    "context": {
        "allowed_regions": {
            "personal": ["eu-west-1", "eu-central-1"],
            "sensitive": ["eu-west-1"]
        },
        "transfer_rules": {
            "GDPR": ["eu-west-1", "eu-central-1"],
            "CCPA": ["us-west-1", "us-east-1"]
        }
    }
}
```

## Integration with OPA

To use these policies with OPA:

1. Load the policies into OPA:
```bash
opa run --server --addr :8181 policies/geolocation/
```

2. Query the policies:
```bash
curl -X POST http://localhost:8181/v1/data/geolocation/access_control/allow \
  -H "Content-Type: application/json" \
  -d @examples/access_control.json
```

## Policy Configuration

### Access Control Settings
- Allowed countries/regions list
- Regional time restrictions
- VPN detection rules
- IP geolocation validation

### Data Residency Settings
- Regional storage restrictions
- Cross-border transfer rules
- Compliance requirement mappings
- Data sovereignty rules

## Contributing

1. Fork the repository
2. Create a feature branch
3. Add your policy
4. Include tests and documentation
5. Submit a pull request 