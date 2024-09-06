#!/bin/bash

# Define color for the output (green)
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Path to the logo image file
logo_path="mastercode.webp"

# Display the logo using catimg (install catimg tool first)
catimg $logo_path

# Ask for subnet range
read -p "Enter the subnet range (e.g., 10.0.0.0/24): " subnet

# Ask for a specific IP (optional)
read -p "Enter a specific IP to scan (or press Enter to skip): " ip

# Ask for the output file to save alive IPs
read -p "Enter the output file name to save alive IPs: " filename

# Check if specific IP is provided
echo "" > "$filename" # Clear the output file before starting

if [ -z "$ip" ]; then
    # If no specific IP is provided, scan the entire subnet
    echo "Scanning subnet $subnet..."
    fping -A -g $subnet 2>/dev/null | while read -r line; do
        alive_ip=$(echo $line | grep "is alive" | cut -d " " -f 1)
        if [ -n "$alive_ip" ]; then
            echo "$alive_ip" >> "$filename"
            # Update the same line with found IPs
            echo -ne "${GREEN}Progress: Found IP: $alive_ip${NC}\r"
        fi
    done
else
    # If specific IP is provided, check its status
    echo "Scanning IP $ip in subnet $subnet..."
    fping -A -g $subnet 2>/dev/null | while read -r line; do
        alive_ip=$(echo $line | grep "$ip is alive" | cut -d " " -f 1)
        if [ -n "$alive_ip" ]; then
            echo "$alive_ip" >> "$filename"
            # Update the same line with found IPs
            echo -ne "${GREEN}Progress: Found IP: $alive_ip${NC}\r"
        fi
    done
fi

# Provide feedback to the user after completion
echo -e "\n"
if [ -s "$filename" ]; then
    echo -e "${GREEN}Alive IPs have been saved to $filename.${NC}"
else
    echo -e "${GREEN}No alive IPs found.${NC}"
fi
