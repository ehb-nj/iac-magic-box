winrm_username        = "vagrant"
winrm_password        = "vagrant"
vm_name               = "WinServer2019x64-cloudinit-raw"
template_description  = "Windows Server 2019 64-bit - template built with Packer - cloudinit - {{isotime \"2006-01-02 03:04:05\"}}"
iso_file              = "local:iso/fr-fr_windows_server_2019_updated_aug_2021_x64_dvd_b863695e.iso"
autounattend_iso      = "./iso/Autounattend_winserver2019_cloudinit.iso"
autounattend_checksum = "sha256:7fc6411b8e19a13bb759bd5897a638cb5dad464099dc6108bfad7d8a4a0576bb"
scripts_iso           = "./iso/scripts_withcloudinit.iso"
scripts_checksum      = "sha256:8eeccc0aa7715970002c0ceaa70f205fc674f5916a4d264e5e2d11c178a1bd19"
vm_cpu_cores          = "2"
vm_memory             = "4096"
vm_disk_size          = "40G"
vm_sockets            = "1"
os                    = "win10"
virtio_iso            = "local:iso/virtio-win-0.1.240.iso"