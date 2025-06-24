# General scripts

These scripts perform the following general functions:

* **dis_acs** - Disables ACS on all detected devices. Note that it still may be necessary to disable ACS from the BIOS depending on hardware support.
* **rccl_test_install** - Clones and configures [rccl-tests](https://github.com/ROCm/rccl-tests) in the location the script is run in. You must manually edit the script the provide directory paths for MPI and RCCL prior to running.
* **set_nic_speed** - Automatically sets available NICs to 200G speed, full duplex, and disables autonegotation. Requires `ethtool` installed.
