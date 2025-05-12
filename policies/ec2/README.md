# AWS EC2 Policies

This directory contains Open Policy Agent (OPA) policies for enforcing standards and security requirements for AWS EC2 instances.

## Policies

### 1. Instance Standards (`instance_standards.rego`)
Enforces EC2 instance configuration standards:
- Instance type restrictions
- AMI requirements
- Tagging standards
- Naming conventions

### 2. Security Groups (`security_groups.rego`)
Enforces security group rules:
- Port restrictions
- CIDR block validation
- Rule descriptions
- Group naming conventions

### 3. Storage (`storage.rego`)
Enforces storage requirements:
- Volume type restrictions
- Encryption requirements
- Size limits
- Backup policies

## Usage

### Testing Policies

```bash
# Test instance standards policy
opa eval --input examples/instance_standards.json --data policies/ec2 "data.ec2.instance_standards.allow"

# Test security groups policy
opa eval --input examples/security_groups.json --data policies/ec2 "data.ec2.security_groups.allow"

# Test storage policy
opa eval --input examples/storage.json --data policies/ec2 "data.ec2.storage.allow"
```

### Example Input

#### Instance Standards
```json
{
    "instance": {
        "instance_type": "t3.medium",
        "ami_id": "ami-0c55b159cbfafe1f0",
        "tags": {
            "Name": "prod-web-server-01",
            "Environment": "production",
            "Team": "platform"
        }
    },
    "context": {
        "allowed_instance_types": ["t3.small", "t3.medium", "t3.large"],
        "required_tags": ["Name", "Environment", "Team"],
        "naming_pattern": "^[a-z]+-[a-z]+-[a-z0-9]+$"
    }
}
```

#### Security Groups
```json
{
    "security_group": {
        "name": "prod-web-sg",
        "description": "Security group for production web servers",
        "rules": [
            {
                "type": "ingress",
                "protocol": "tcp",
                "from_port": 80,
                "to_port": 80,
                "cidr_blocks": ["0.0.0.0/0"],
                "description": "Allow HTTP traffic"
            },
            {
                "type": "ingress",
                "protocol": "tcp",
                "from_port": 443,
                "to_port": 443,
                "cidr_blocks": ["0.0.0.0/0"],
                "description": "Allow HTTPS traffic"
            }
        ]
    }
}
```

#### Storage
```json
{
    "volume": {
        "type": "gp3",
        "size": 100,
        "encrypted": true,
        "tags": {
            "Name": "prod-web-server-01-data",
            "Environment": "production"
        }
    },
    "context": {
        "allowed_volume_types": ["gp3", "io2"],
        "max_size": 1000,
        "encryption_required": true,
        "required_tags": ["Name", "Environment"]
    }
}
```

## Integration with OPA

To use these policies with OPA:

1. Load the policies into OPA:
```bash
opa run --server --addr :8181 policies/ec2/
```

2. Query the policies:
```bash
curl -X POST http://localhost:8181/v1/data/ec2/instance_standards/allow \
  -H "Content-Type: application/json" \
  -d @examples/instance_standards.json
```

## Policy Configuration

### Instance Standards
- Allowed instance types
- Required AMI properties
- Tagging requirements
- Naming conventions

### Security Groups
- Port restrictions
- CIDR block rules
- Rule description requirements
- Group naming patterns

### Storage
- Volume type restrictions
- Size limits
- Encryption requirements
- Backup policies

## Contributing

1. Fork the repository
2. Create a feature branch
3. Add your policy
4. Include tests and documentation
5. Submit a pull request 