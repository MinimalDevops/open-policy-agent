# Kubernetes Policies

This repository contains a collection of Open Policy Agent (OPA) policies for Kubernetes. These policies enforce best practices, security standards, and operational requirements across your Kubernetes clusters.

## Policy Categories

### 1. Admission Policies (`kubernetes/admission/`)
Policies that enforce standards during resource creation and modification:
- Resource limits and requests
- Root container prevention
- Required labels and annotations
- Image registry restrictions

### 2. CRD Policies (`kubernetes/crd/`)
Policies for validating Custom Resource Definitions and GitOps workflows:
- ArgoCD Application naming conventions
- Helm Release standards
- Kustomization requirements

### 3. Audit Policies (`kubernetes/audit/`)
Policies for auditing existing resources:
- Comprehensive violation detection
- Detailed reporting
- Dry-run mode support

## Getting Started

### Prerequisites

- Open Policy Agent (OPA) v0.20.0 or later
- Kubernetes cluster (for Gatekeeper integration)
- OPA Gatekeeper (for admission control)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/your-org/kubernetes-policies.git
cd kubernetes-policies
```

2. Install OPA:
```bash
# macOS
brew install opa

# Linux
curl -L -o opa https://github.com/open-policy-agent/opa/releases/download/v0.20.0/opa_linux_amd64
chmod +x opa
sudo mv opa /usr/local/bin/
```

3. Install OPA Gatekeeper:
```bash
kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper/master/deploy/gatekeeper.yaml
```

### Testing Policies

1. Test individual policies:
```bash
# Test admission policies
opa eval --input examples/admission.json --data policies/kubernetes/admission "data.kubernetes.admission.allow"

# Test CRD policies
opa eval --input examples/crd.json --data policies/kubernetes/crd "data.kubernetes.crd.allow"

# Test audit policies
opa eval --input examples/audit.json --data policies/kubernetes/audit "data.kubernetes.audit.allow"
```

2. Run policy tests:
```bash
opa test policies/kubernetes/
```

## Integration with OPA Gatekeeper

1. Create ConstraintTemplates:
```bash
kubectl apply -f templates/
```

2. Create Constraints:
```bash
kubectl apply -f constraints/
```

3. Verify installation:
```bash
kubectl get constrainttemplates
kubectl get constraints
```

## Policy Development

### Adding New Policies

1. Create a new policy file in the appropriate directory
2. Write the policy in Rego
3. Add tests
4. Update documentation
5. Submit a pull request

### Policy Structure

Each policy should:
- Have a clear purpose
- Include comprehensive tests
- Provide example inputs
- Document integration steps
- Follow Rego best practices

## Contributing

1. Fork the repository
2. Create a feature branch
3. Add your policy
4. Include tests and documentation
5. Submit a pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details. 