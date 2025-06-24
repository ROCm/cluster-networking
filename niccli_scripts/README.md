# NICCLI configuration scripts

These scripts are for use with Broadcom network adapters that support the `niccli` command. For specific information about all `niccli` commands, consult the [Broadcom NICCLI documentation](https://techdocs.broadcom.com/us/en/storage-and-ethernet-connectivity/ethernet-nic-controllers/bcm957xxx/adapters/Configuration-adapter/nic-cli-configuration-utility.html).

## Script description

Each script performs a distinct function:

* **niccli_rdma_config** - Checks that each NIC has RMDA support enabled (`support_rdma = True`), if supported. If not enabled, the script updates the configuration.
* **niccli_ro_config**  - Checks that each NIC has PCIE relaxed ordering enabled (`pcie_relaxed_ordering = Enabled`). If not enabled, the script updates the configuration.
* **niccli_set_profile** - Checks that each NIC has a RoCE performance profile enabled (`performance_profile = RoCE`), if supported. If not enabled, the script updates the configuration.
* **niccli_speedmask** - Checks the each NIC has PAM-4 speeds enabled (`autodetect_speed_exclude_mask = 200G|50G_PAM4|100G_PAM4`), if supported. If not enabled, the script updates the configuration.

## How to exclude devices

Your node may have NICs that you don't want the scripts to take any action (For example, frontend NICs that aren't used for GPU-to-GPU communication). If this is the case, each script contains an `exclude_list` array that can be populated with the interface names (as shown under the `Device Interface Name` in `sudo niccli --listdev` for any NICs that should be skipped in script's main loop. Edit the relevant line of script as follows:

`exclude_list=("<interface-1>" "<interface-2>")`
