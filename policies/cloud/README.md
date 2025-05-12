# Cloud Policies

This directory contains Open Policy Agent (OPA) policies for enforcing cloud infrastructure standards and security requirements across multiple cloud providers.

## Policies

### 1. Multi-Cloud Standards (`multi_cloud_standards.rego`)
Enforces consistent standards across cloud providers:
- Resource naming conventions
- Tagging requirements
- Cost allocation
- Compliance standards

### 2. Cloud Security (`cloud_security.rego`)
Enforces security requirements:
- Encryption standards
- Access control policies
- Network security rules
- Compliance requirements

### 3. Resource Management (`resource_management.rego`)
Enforces resource management policies:
- Resource quotas
- Cost optimization
- Resource lifecycle
- Backup requirements

## Usage

### Testing Policies

```bash
# Test multi-cloud standards policy
opa eval --input examples/multi_cloud_standards.json --data policies/cloud "data.cloud.multi_cloud_standards.allow"

# Test cloud security policy
opa eval --input examples/cloud_security.json --data policies/cloud "data.cloud.cloud_security.allow"

# Test resource management policy
opa eval --input examples/resource_management.json --data policies/cloud "data.cloud.resource_management.allow"
```

### Example Input

#### Multi-Cloud Standards
```json
{
    "resource": {
        "provider": "aws",
        "type": "ec2",
        "name": "prod-web-server-01",
        "tags": {
            "environment": "production",
            "cost-center": "platform",
            "team": "backend"
        }
    },
    "context": {
        "naming_conventions": {
            "pattern": "^[a-z]+-[a-z]+-[a-z0-9]+$",
            "required_parts": ["env", "type", "number"]
        },
        "required_tags": ["environment", "cost-center", "team"]
    }
}
```

#### Cloud Security
```json
{
    "resource": {
        "provider": "aws",
        "type": "s3",
        "encryption": {
            "enabled": true,
            "type": "AES-256"
        },
        "access_control": {
            "public_access": false,
            "bucket_policy": {
                "version": "2012-10-17",
                "statement": [
                    {
                        "effect": "Deny",
                        "principal": "*",
                        "action": "s3:*",
                        "condition": {
                            "Bool": {
                                "aws:SecureTransport": "false"
                            }
                        }
                    }
                ]
            }
        }
    }
}
```

#### Resource Management
```json
{
    "resource": {
        "provider": "aws",
        "type": "rds",
        "specs": {
            "instance_type": "db.t3.medium",
            "storage": 100,
            "backup_retention": 7
        },
        "tags": {
            "environment": "production",
            "backup_schedule": "daily"
        }
    },
    "context": {
        "quota_limits": {
            "rds": {
                "max_instances": 10,
                "max_storage": 1000
            }
        },
        "backup_requirements": {
            "production": {
                "retention_days": 7,
                "schedule": "daily"
            }
        }
    }
}
```

## Integration with OPA

To use these policies with OPA:

1. Load the policies into OPA:
```bash
opa run --server --addr :8181 policies/cloud/
```

2. Query the policies:
```bash
curl -X POST http://localhost:8181/v1/data/cloud/multi_cloud_standards/allow \
  -H "Content-Type: application/json" \
  -d @examples/multi_cloud_standards.json
```

## Policy Configuration

### Multi-Cloud Standards
- Resource naming patterns
- Required tags and labels
- Cost allocation rules
- Compliance requirements

### Cloud Security
- Encryption requirements
- Access control policies
- Network security rules
- Compliance standards

### Resource Management
- Resource quotas
- Cost optimization rules
- Lifecycle policies
- Backup requirements

## Contributing

1. Fork the repository
2. Create a feature branch
3. Add your policy
4. Include tests and documentation
5. Submit a pull request 