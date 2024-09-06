#!/bin/bash

# Ask for subnet range
read -p "Enter the subnet range (e.g., 10.0.0.0/24): " subnet

# Ask for a specific IP (optional)
read -p "Enter a specific IP to scan (or press Enter to skip): " ip

# Ask for the output file to save alive IPs
read -p "Enter the output file name to save alive IPs: " filename

# Check if specific IP is provided
if [ -z "$ip" ]; then
    # If no specific IP is provided, scan the entire subnet
    echo "Scanning subnet $subnet..."
    fping -A -g $subnet 2>/dev/null | grep "is alive" | cut -d " " -f 1 > "$filename"
else
    # If specific IP is provided, check its status
    echo "Scanning IP $ip in subnet $subnet..."
    fping -A -g $subnet 2>/dev/null | grep "$ip is alive" | cut -d " " -f 1 > "$filename"
fi

# Provide feedback to the user
if [ -s "$filename" ]; then
    echo "Alive IPs have been saved to $filename."
else
    echo "No alive IPs found."
fi
