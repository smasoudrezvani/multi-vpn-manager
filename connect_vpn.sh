#!/bin/bash

CONFIG_DIR="$HOME/.vpn_profiles"

# List available VPN profiles
echo "Available VPN Profiles:"
ls "$CONFIG_DIR"/*.conf | xargs -n 1 basename | sed 's/.conf//'

# Ask user to select a VPN profile
read -p "Enter the VPN name to connect: " vpn_name
VPN_CONFIG="$CONFIG_DIR/$vpn_name.conf"

# Check if the config file exists
if [ ! -f "$VPN_CONFIG" ]; then
   echo "Error: VPN profile '$vpn_name' not found!"
   exit 1
fi

# Load the VPN config
host=$(grep '^host=' "$VPN_CONFIG" | cut -d'=' -f2- | tr -d '\r')
port=$(grep '^port=' "$VPN_CONFIG" | cut -d'=' -f2- | tr -d '\r')
user=$(grep '^user=' "$VPN_CONFIG" | cut -d'=' -f2- | tr -d '\r')
password=$(grep '^password=' "$VPN_CONFIG" | cut -d'=' -f2- | tr -d '\r')
protocol=$(grep '^protocol=' "$VPN_CONFIG" | cut -d'=' -f2- | tr -d '\r')

# Check if openfortivpn is installed if needed
if [ "$protocol" == "openfortivpn" ]; then
    if ! command -v openfortivpn &> /dev/null; then
        echo "Error: openfortivpn is not installed. Please install it using: sudo apt update && sudo apt install openfortivpn"
        exit 1
    fi
    
    echo "Connecting using openfortivpn..."
    sudo openfortivpn "$host":"$port" -u "$user" -p "$password" --trusted-cert f19a72523e24fff1dd45a1eacfce5dc9f6e5c5c460e4ceb0ac9dfc81c0228b42 2>&1 | tee vpn_log.txt
    
    if grep -q "Certificate from VPN server" vpn_log.txt; then
        server_cert=$(grep -o 'pin-sha256:[^ ]*' vpn_log.txt | head -n 1)
        if [ -n "$server_cert" ]; then
            echo "Using suggested server certificate: $server_cert"
            sudo openfortivpn "$host":"$port" -u "$user" -p "$password" --servercert "$server_cert" --non-inter
        else
            echo "Error: Unable to extract server certificate hash. Please check manually."
            exit 1
        fi
    fi
    
else
    echo "Connecting using openconnect..."
    echo "$password" | sudo openconnect --protocol="$protocol" "https://$host:$port" -u "$user" --passwd-on-stdin
fi

