winrm_username = "vagrant"
winrm_password = "vagrant"
vm_name = "Win10x64-cloudinit-raw"
template_description = "Windows 10 64-bit - 22H2 - template built with Packer - cloudinit - {{isotime \"2006-01-02 03:04:05\"}}"
iso_file = "local:iso/Win10_22H2_French_x64.iso"
autounattend_iso = "./iso/Autounattend_win10_cloudinit.iso"
autounattend_checksum = "sha256:5ed4eb5e210b92dc457a90f3afaa85f9723d2dfcde63448140ff5f241247adfc"
vm_cpu_cores = "2"
vm_memory = "4096"
vm_disk_size = "40G"
vm_sockets = "1"
os = "win10"