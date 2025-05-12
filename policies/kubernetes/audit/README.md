# Kubernetes Audit Policies

This directory contains Open Policy Agent (OPA) policies for auditing Kubernetes resources. These policies help identify violations of best practices and security standards in existing resources.

## Policies

### 1. Audit Mode (`audit_mode.rego`)
Provides comprehensive audit functionality:
- Detects violations across all policies
- Generates detailed violation reports
- Supports dry-run mode for testing
- Formats violation messages for clarity

## Usage

### Testing Policies

```bash
# Run audit mode
opa eval --input examples/audit_mode.json --data policies/kubernetes/audit "data.kubernetes.audit.audit_mode.audit"

# Run dry-run mode
opa eval --input examples/audit_mode.json --data policies/kubernetes/audit "data.kubernetes.audit.audit_mode.dry_run"
```

### Example Input

```json
{
    "resource": {
        "metadata": {
            "name": "example-pod",
            "labels": {
                "cost-center": "platform",
                "team": "backend",
                "environment": "prod"
            },
            "annotations": {
                "owner": "team-platform",
                "managed-by": "argocd"
            }
        },
        "spec": {
            "containers": [
                {
                    "name": "app",
                    "image": "docker.io/myapp:1.0.0",
                    "resources": {
                        "limits": {
                            "cpu": "500m",
                            "memory": "512Mi"
                        },
                        "requests": {
                            "cpu": "100m",
                            "memory": "128Mi"
                        }
                    },
                    "securityContext": {
                        "runAsUser": 1000,
                        "readOnlyRootFilesystem": true
                    }
                }
            ]
        }
    }
}
```

### Example Output

#### Audit Mode
```json
{
    "violations": [
        {
            "msg": "Found 2 violations: Missing required label 'cost-center', Missing required annotation 'owner'"
        }
    ]
}
```

#### Dry Run Mode
```json
{
    "report": [
        {
            "resource": "example-pod",
            "violations": [
                {
                    "policy": "labels_annotations",
                    "message": "Missing required label 'cost-center'"
                },
                {
                    "policy": "labels_annotations",
                    "message": "Missing required annotation 'owner'"
                }
            ]
        }
    ]
}
```

## Integration with OPA Gatekeeper

To use these policies with OPA Gatekeeper:

1. Create ConstraintTemplates for each policy
2. Create Constraints using these templates
3. Configure audit mode in Gatekeeper

Example ConstraintTemplate:

```yaml
apiVersion: templates.gatekeeper.sh/v1
kind: ConstraintTemplate
metadata:
  name: k8sauditpolicies
spec:
  crd:
    spec:
      names:
        kind: K8sAuditPolicies
  targets:
    - target: admission.k8s.gatekeeper.sh
      rego: |
        package kubernetes.audit
        # ... policy content ...
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Add your policy
4. Include tests and documentation
5. Submit a pull request 