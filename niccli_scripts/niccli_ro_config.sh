#!/bin/bash

# Set up ANSI colors

RED="\e[31m"
GREEN="\e[92m"
YELLOW="\e[93m"
NC="\e[0m" # No color

# Check if niccli is installed
if ! command -v niccli &> /dev/null; then
    echo "niccli utility is not installed. Please install it and try again."
    exit 1
fi

echo "Starting script..."

# Get list of PCI addresses
pci_addresses=$(sudo niccli --listdev 2>/dev/null | grep "PCI Address" | awk '{print $4}')
# Provide interface names for any devices you want excluded from the script in space-separated quotations ("enp171s0np0" "enp33s0f1np1"), otherwise leave empty
exclude_list=("")
# Check and set relaxed ordering
for address in $pci_addresses; do
    # Extract interface names
    net_if=$(sudo niccli -pci $address device_info 2>/dev/null | grep "Interface Name" | awk '{print $4}')
    # Skip any devices entered in exclude_list
    for exclude_if in ${exclude_list[@]}; do
        if [[ "$net_if" == "$exclude_if" ]]; then
            continue 2
        fi
    done
    #Extract device name    
    net_device=$(sudo niccli -pci $address device_info 2>/dev/null | grep "Description" | awk '{$1=$2=""; sub(/^  +/, ""); print }')
    # Check current relaxed ordering setting
    current_setting=$(sudo niccli -pci $address nvm -getoption pcie_relaxed_ordering 2>/dev/null)
    
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed${NC} ${YELLOW}to get relaxed ordering setting for $net_if - $net_device ($address). Skipping...${NC}"
        continue
    fi

    echo -e "${YELLOW}Checking relaxed ordering status for $net_if - $net_device ($address)...${NC}"

    # Set relaxed ordering if not enabled
    if [[ ! "$current_setting" == *"Enabled"* ]]; then
        echo -e "Relaxed ordering is ${RED}not${NC} set. Enabling..."
        sudo niccli -pci $address nvm -setoption pcie_relaxed_ordering -value 1 >/dev/null 2>&1
        
        if [ $? -eq 0 ]; then
            echo "Successfully set relaxed ordering."
        else
            echo -e "${RED}Failed${NC} to set relaxed ordering."
        fi
    else
       echo -e "Relaxed ordering is ${GREEN}already enabled${NC}."
    fi
done
