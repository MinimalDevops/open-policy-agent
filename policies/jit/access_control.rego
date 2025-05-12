package jit.access

import data.jit.session
import data.jit.aws

default allow = false

# Main JIT access control policy
allow {
    # Check if session is valid
    session.is_valid(input.session_id)
    
    # Check if user has requested access
    has_requested_access(input.user, input.resource)
    
    # Check if request is approved
    is_request_approved(input.request_id)
    
    # Check if session is within time limits
    is_within_time_limits(input.session_id)
}

# Check if user has requested access
has_requested_access(user, resource) {
    request := get_access_request(user, resource)
    request.status == "pending"
    request.timestamp > time.now_ns() - 3600000000000  # Within last hour
}

# Check if request is approved
is_request_approved(request_id) {
    request := get_request_by_id(request_id)
    request.status == "approved"
    request.approved_by != ""
}

# Check if session is within time limits
is_within_time_limits(session_id) {
    session := session.get_session(session_id)
    session.start_time > time.now_ns() - 3600000000000  # Started within last hour
    session.end_time > time.now_ns()  # Not expired
}

# Get access request
get_access_request(user, resource) = request {
    access_requests[user][resource] = request
}

# Get request by ID
get_request_by_id(request_id) = request {
    requests[request_id] = request
}

# Example access request structure
access_requests = {
    "user1": {
        "arn:aws:ec2:*:*:instance/*": {
            "status": "pending",
            "timestamp": "2024-03-20T10:00:00Z",
            "request_id": "req-123"
        }
    }
}

# Example requests
requests = {
    "req-123": {
        "status": "approved",
        "approved_by": "admin1",
        "approval_time": "2024-03-20T10:05:00Z"
    }
}

# Session time limits
session_limits = {
    "max_duration": 3600,  # 1 hour in seconds
    "min_duration": 300    # 5 minutes in seconds
} 