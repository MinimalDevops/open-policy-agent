package geolocation.access

import data.geolocation.ip_lookup

default allow = false

# Main geolocation-based access control policy
allow {
    # Get geolocation data for IP
    location := ip_lookup.get_location(input.source_ip)
    
    # Check if country is allowed
    is_country_allowed(location.country_code)
    
    # Check if region is allowed
    is_region_allowed(location.region)
    
    # Check if timezone is within allowed range
    is_timezone_allowed(location.timezone)
}

# Check if country is allowed
is_country_allowed(country_code) {
    allowed_countries[country_code]
}

# Check if region is allowed
is_region_allowed(region) {
    allowed_regions[region]
}

# Check if timezone is allowed
is_timezone_allowed(timezone) {
    allowed_timezones[timezone]
}

# Allowed countries (ISO country codes)
allowed_countries = {
    "US",
    "CA",
    "GB",
    "DE",
    "FR"
}

# Allowed regions
allowed_regions = {
    "North America",
    "Europe"
}

# Allowed timezones
allowed_timezones = {
    "America/New_York",
    "America/Los_Angeles",
    "Europe/London",
    "Europe/Berlin",
    "Europe/Paris"
}

# High-risk countries (blocked)
high_risk_countries = {
    "RU",
    "CN",
    "IR"
}

# Block access from high-risk countries
deny {
    location := ip_lookup.get_location(input.source_ip)
    high_risk_countries[location.country_code]
} 