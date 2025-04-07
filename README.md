
# 🔐 Open Policy Agent (OPA) Policy Collection

This repository is a growing collection of **modular, production-ready Rego policies** built with [Open Policy Agent (OPA)](https://www.openpolicyagent.org/). These policies help implement **fine-grained, context-aware access control** across cloud infrastructure, APIs, workloads, and developer environments.

🧠 Each policy is documented and explained with a detailed, real-world blog post.

---

## 📚 Use Cases & Blog Guides

| Category         | Use Case                                                           | Blog Post |
|------------------|---------------------------------------------------------------------|-----------|
| 🖥️ EC2 Access Control | **Time-based & IP-based SSH access to EC2 using Bastion Host + OPA** | [Read blog →](https://medium.com/@minimaldevops/time-based-ec2-access-with-opa-enforcing-secure-ssh-access-using-open-policy-agent-ac03ef43102f?sk=1a1a7b61823a6c7763af267858d57c4e) |
| ☁️ Coming Soon   | Role-based access across multiple clouds (AWS, Azure, GCP)         | _TBD_ |
| 🔐 Coming Soon   | OPA + Kubernetes Admission Controllers                              | _TBD_ |
| 🌐 Coming Soon   | Geolocation-based policy enforcement using external IP APIs         | _TBD_ |
| 🚀 Coming Soon   | Just-in-Time access with Session Manager + Lambda + OPA            | _TBD_ |

---

## 🗂️ Repository Structure

```
opa-access-policies/
├── policies/             # All Rego policy files, organized by use case
│   ├── ec2/              # EC2-specific access control
│   └── ...
├── examples/             # JSON input examples for testing policies
├── scripts/              # ForceCommand shell scripts, Lambda handlers, etc.
├── docs/                 # Diagrams and architectural references
├── test/                 # Optional Rego test files for `opa test`
├── README.md             # This file
└── LICENSE
```

---

## 🛠️ Quickstart

### 1. Install OPA

```bash
wget https://openpolicyagent.org/downloads/latest/opa_linux_amd64 -O /usr/local/bin/opa
chmod +x /usr/local/bin/opa
```

### 2. Run OPA Server

```bash
opa run --server --watch ./policies
```

### 3. Test a Policy with Sample Input

```bash
opa eval --input examples/ec2/input.json \
         --data policies \
         "data.ec2.access.allow"
```

Or use the HTTP API:

```bash
curl -X POST localhost:8181/v1/data/ec2/access \
  -H "Content-Type: application/json" \
  -d @examples/ec2/input.json
```

---

## 📜 Sample Rego Snippet: Time-Based + IP Access Control

```rego
package ec2.access

default allow = false

allowed_ips = {
  "203.0.113.5",
  "198.51.100.22"
}

allowed_subnets = [
  "203.0.113.0/24",
  "198.51.100.0/24"
]

allow {
  input.user == "anchal"
  input.action == "ssh"
  is_within_hours(input.timestamp)
  is_ip_allowed(input.source_ip)
}

is_ip_allowed(ip) {
  allowed_ips[ip]
} else {
  some subnet
  net.cidr_contains(subnet, ip)
}

is_within_hours(ts) {
  t := time.parse_rfc3339_ns(ts)
  hour := time.hour(t)
  hour >= 9
  hour < 17
}
```

---

## 🧪 Testing Policies

OPA supports automated testing using the `opa test` command.

```bash
opa test ./policies
```

You can also include Rego test files under `test/` or alongside policies.

---

## ✅ Roadmap

- [ ] Add policies for Azure VM and GCP instances
- [ ] Implement geolocation-based access rules
- [ ] Integrate `opa test` into GitHub Actions
- [ ] Add Terraform + OPA integration samples
- [ ] Role- and context-based RBAC modules

---

## 🙌 Contributing

Contributions are welcome!

1. Fork the repo
2. Add your policy under `policies/<category>`
3. Include a sample input in `examples/<category>/`
4. Submit a PR with a short description (and a blog if available!)

---

## 📄 License

MIT © [Minimal DevOps](https://www.minimaldevops.com)
