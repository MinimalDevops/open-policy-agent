package ec2.ip_validation

# Allowed IP addresses
allowed_ips = {
    "203.0.113.5",
    "198.51.100.22"
}

# Allowed subnets
allowed_subnets = [
    "203.0.113.0/24",
    "198.51.100.0/24"
]

# Check if IP is allowed
is_ip_allowed(ip) {
    allowed_ips[ip]
} else {
    some subnet
    net.cidr_contains(subnet, ip)
} 