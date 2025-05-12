# Kubernetes CRD Policies

This directory contains Open Policy Agent (OPA) policies for validating Custom Resource Definitions (CRDs) and GitOps workflows. These policies enforce standards for ArgoCD Applications, HelmReleases, and Kustomizations.

## Policies

### 1. ArgoCD Naming (`argocd_naming.rego`)
Enforces naming conventions for ArgoCD Applications:
- Pattern: `<team>-<env>-<app>`
- Validates team and environment against allowed lists
- Ensures project matches team name
- Allowed teams: platform, backend, frontend, data
- Allowed environments: dev, staging, prod

### 2. Helm Release (`helm_release.rego`)
Enforces standards for HelmReleases:
- Requires versioned charts with valid semver
- Enforces use of `valuesFrom` for configuration
- Follows naming convention: `<team>-<env>-<app>`
- Validates chart version format

### 3. Kustomization (`kustomization.rego`)
Enforces standards for Kustomizations:
- Follows naming convention: `<team>-<env>-<app>`
- Requires essential fields: path, targetNamespace, sourceRef
- Enforces proper directory structure
- Validates kustomization.yaml presence
- Ensures config directory structure

## Usage

### Testing Policies

```bash
# Test ArgoCD naming policy
opa eval --input examples/argocd_naming.json --data policies/kubernetes/crd "data.kubernetes.crd.argocd_naming.allow"

# Test Helm release policy
opa eval --input examples/helm_release.json --data policies/kubernetes/crd "data.kubernetes.crd.helm_release.allow"

# Test Kustomization policy
opa eval --input examples/kustomization.json --data policies/kubernetes/crd "data.kubernetes.crd.kustomization.allow"
```

### Example Inputs

#### ArgoCD Application
```json
{
    "resource": {
        "metadata": {
            "name": "platform-prod-api"
        },
        "spec": {
            "project": "platform",
            "source": {
                "repoURL": "https://github.com/org/repo",
                "path": "apps/api",
                "targetRevision": "main"
            }
        }
    }
}
```

#### Helm Release
```json
{
    "resource": {
        "metadata": {
            "name": "platform-prod-api"
        },
        "spec": {
            "chart": {
                "spec": {
                    "chart": "api",
                    "version": "1.0.0",
                    "sourceRef": {
                        "kind": "HelmRepository",
                        "name": "platform"
                    }
                }
            },
            "valuesFrom": [
                {
                    "kind": "ConfigMap",
                    "name": "platform-prod-api-values"
                }
            ]
        }
    }
}
```

#### Kustomization
```json
{
    "resource": {
        "metadata": {
            "name": "platform-prod-api"
        },
        "spec": {
            "path": "./apps/api/overlays/prod",
            "targetNamespace": "platform-prod",
            "sourceRef": {
                "kind": "GitRepository",
                "name": "platform-repo"
            }
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
  name: k8scrdpolicies
spec:
  crd:
    spec:
      names:
        kind: K8sCrdPolicies
      validation:
        openAPIV3Schema:
          properties:
            allowedTeams:
              type: array
              items:
                type: string
            allowedEnvironments:
              type: array
              items:
                type: string
  targets:
    - target: admission.k8s.gatekeeper.sh
      rego: |
        package kubernetes.crd
        # ... policy content ...
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Add your policy
4. Include tests and documentation
5. Submit a pull request 