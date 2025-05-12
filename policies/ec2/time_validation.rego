package ec2.time_validation

# Check if the time is within allowed hours
is_within_allowed_hours(ts) {
    t := time.parse_rfc3339_ns(ts)
    hour := time.hour(t)
    hour >= 9
    hour < 17
}

# Check if the day is a working day
is_working_day(ts) {
    t := time.parse_rfc3339_ns(ts)
    day := time.weekday(t)
    day != "Sunday"
    day != "Saturday"
} 