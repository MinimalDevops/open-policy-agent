package ec2.access

import data.ec2.ip_validation
import data.ec2.time_validation

default allow = false

# Main policy rule that combines all checks
allow {
    # Basic user authentication
    input.user != ""
    input.action == "ssh"
    
    # Time-based access control
    time_validation.is_within_allowed_hours(input.timestamp)
    
    # IP-based access control
    ip_validation.is_ip_allowed(input.source_ip)
    
    # Additional security checks
    not is_blacklisted_user(input.user)
    not is_blacklisted_ip(input.source_ip)
}

# Check if user is blacklisted
is_blacklisted_user(user) {
    blacklisted_users[user]
}

# Check if IP is blacklisted
is_blacklisted_ip(ip) {
    blacklisted_ips[ip]
}

# Blacklisted users (example)
blacklisted_users = {
    "blocked_user1",
    "blocked_user2"
}

# Blacklisted IPs (example)
blacklisted_ips = {
    "192.168.1.100",
    "10.0.0.50"
} 