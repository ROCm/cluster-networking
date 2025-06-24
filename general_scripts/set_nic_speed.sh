#!/bin/bash

# Set up ANSI colors

RED="\e[31m"
GREEN="\e[92m"
YELLOW="\e[93m"
NC="\e[0m" # No color

# Check if ethtool is available
if ! command -v ethtool &> /dev/null
then
    echo "ethtool could not be found, please install it first."
    exit 1
fi

# Provide interface names for any devices you want excluded from the script in space-separated quotations ("enp171s0np0" "enp33s0f1np1"), otherwise leave empty
exclude_list=("")

# Iterate over all network interfaces
for iface in $(ls /sys/class/net/); do    
    # Only run on physical interfaces
    if [[ -d "/sys/class/net/$iface/device" ]]; then
        # Skip any devices entered in exclude_list
        for exclude_if in ${exclude_list[@]}; do
            if [[ "$iface" == "$exclude_if" ]]; then
                continue 2
            fi
        done
        echo -e "${YELLOW}Configuring $iface...${NC}"
        # Disable autonegotiation, set speed to 200G, and duplex to full
        ethtool -s "$iface" autoneg off speed 200000 duplex full
        if [[ $? -ne 0 ]]; then
            echo "Failed to configure $iface."
        else
            echo "$iface configured successfully."
        fi
    fi
done

echo "Configuration complete."
