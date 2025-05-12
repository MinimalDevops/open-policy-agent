# Kubernetes Admission Policies

This directory contains Open Policy Agent (OPA) policies for Kubernetes admission control. These policies enforce best practices and security standards during resource creation and modification.

## Policies

### 1. Resource Limits (`resource_limits.rego`)
Enforces resource limits and requests on containers:
- Requires CPU and memory limits
- Requires CPU and memory requests
- Validates resource format (e.g., "500m", "1Gi")

### 2. Root Containers (`root_containers.rego`)
Prevents containers from running as root:
- Blocks containers with `runAsUser: 0`
- Requires explicit security context
- Enforces non-root user configuration

### 3. Labels and Annotations (`labels_annotations.rego`)
Enforces required labels and annotations:
- Required labels: cost-center, team, environment
- Required annotations: owner, managed-by
- Validates label and annotation presence

### 4. Image Registry (`image_registry.rego`)
Restricts container image sources:
- Allows only specified registries
- Supports multiple registry patterns
- Validates image references

## Usage

### Testing Policies

```bash
# Test resource limits policy
opa eval --input examples/resource_limits.json --data policies/kubernetes/admission "data.kubernetes.admission.resource_limits.allow"

# Test root containers policy
opa eval --input examples/root_containers.json --data policies/kubernetes/admission "data.kubernetes.admission.root_containers.allow"

# Test labels and annotations policy
opa eval --input examples/labels_annotations.json --data policies/kubernetes/admission "data.kubernetes.admission.labels_annotations.allow"

# Test image registry policy
opa eval --input examples/image_registry.json --data policies/kubernetes/admission "data.kubernetes.admission.image_registry.allow"
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

## Integration with OPA Gatekeeper

To use these policies with OPA Gatekeeper:

1. Create ConstraintTemplates for each policy
2. Create Constraints using these templates
3. Apply the Constraints to your cluster

Example ConstraintTemplate:

```yaml
apiVersion: templates.gatekeeper.sh/v1
kind: ConstraintTemplate
metadata:
  name: k8sadmissionpolicies
spec:
  crd:
    spec:
      names:
        kind: K8sAdmissionPolicies
      validation:
        openAPIV3Schema:
          properties:
            allowedRegistries:
              type: array
              items:
                type: string
  targets:
    - target: admission.k8s.gatekeeper.sh
      rego: |
        package kubernetes.admission
        # ... policy content ...
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Add your policy
4. Include tests and documentation
5. Submit a pull request 