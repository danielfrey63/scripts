#!/bin/bash

# Function to check if user is currently logged in
is_logged_in() {
    local username="$1"
    who | grep -q "^$username "
}

# Print header
printf "%-12s %-6s %-8s %-20s %-15s %-25s %s\n" "USERNAME" "UID" "STATUS" "HOME" "SHELL" "LAST LOGIN" "CURRENT SESSIONS"
printf "%-12s %-6s %-8s %-20s %-15s %-25s %s\n" "--------" "---" "------" "----" "-----" "----------" "----------------"

# Process users
getent passwd | awk -F: '$3 >= 1000 && $3 != 65534 { print $1, $3, $6, $7 }' | while read user uid home shell; do
  if [[ "$shell" != "/usr/sbin/nologin" && "$shell" != "/bin/false" && "$shell" != "/sbin/nologin" ]]; then
    
    # Get last login info
    last_login_raw=$(lastlog -u "$user" 2>/dev/null | tail -n 1)
    if echo "$last_login_raw" | grep -q "Never logged in"; then
      last_login="Never logged in"
    else
      last_login=$(echo "$last_login_raw" | awk '{if(NF>3) print $4" "$5" "$6; else print "Never logged in"}')
    fi
    
    # Check if currently logged in and get session info
    if is_logged_in "$user"; then
      status="ONLINE"
      sessions=$(who | grep "^$user " | wc -l)
      current_sessions="${sessions} session(s)"
    else
      status="OFFLINE"
      current_sessions="-"
    fi
    
    # Format shell name (remove path)
    shell_name=$(basename "$shell")
    
    # Print formatted row
    printf "%-12s %-6s %-8s %-20s %-15s %-25s %s\n" \
           "$user" "$uid" "$status" "$home" "$shell_name" "$last_login" "$current_sessions"
  fi
done
