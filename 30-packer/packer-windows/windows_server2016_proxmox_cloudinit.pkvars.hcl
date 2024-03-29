autounattend_checksum = "sha256:bd99d636037f5fe9ef1b24da8152388f7287d173a5b846bb4e4148f5154a29eb"
autounattend_iso      = "./iso/Autounattend_winserver2016_cloudinit.iso"
iso_file              = "local:iso/fr_windows_server_2016_updated_feb_2018_x64_dvd_11636707.iso"
os                    = "win10"
scripts_checksum      = "sha256:8eeccc0aa7715970002c0ceaa70f205fc674f5916a4d264e5e2d11c178a1bd19"
scripts_iso           = "./iso/scripts_withcloudinit.iso"
template_description  = "Windows Server 2016 64-bit - template built with Packer - cloudinit - {{isotime \"2006-01-02 03:04:05\"}}"
virtio_iso            = "local:iso/virtio-win-0.1.240.iso"
vm_cpu_cores          = "2"
vm_disk_size          = "40G"
vm_memory             = "4096"
vm_name               = "WinServer2016x64-cloudinit-raw"
vm_sockets            = "1"
winrm_password        = "vagrant"
winrm_username        = "vagrant"
