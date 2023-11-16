# Packer Windows

The aim of this section is to build Windows images that can be cloned with Terraform.

## Requirements

Install "Packer" on your client machine.

Create the templates in a Network with DHCP available and Internet connexion for Widows Updates.

We need to have an HTTPS connexion from your machine to the Proxmox server. You also need WINRM connexion between the templates created (2 TCP ports need to be opened : 5985, 5986).

### MacOS
```
brew tap hashicorp/tap
brew install hashicorp/tap/packer
```

### Ubuntu
```
apt update
apt -y install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
apt update
apt install packer
```

### Cloudbase-Init 

Cloudbase-Init is the Windows version of Cloud-Init.
Download here : https://cloudbase.it/cloudbase-init/
Put the msi here (and rename it) :
```
packer/packer-windows/sysprep/CloudbaseInitSetup_Stable_x64.msi
```

## Build ISO images

### Download the ISOs

You need to download Windows ISOs. By default, autounattend scripts use the French version of Windows images. If you need to modify the language parameters, you must do so in each Autounattend.xml script in the answer_file directory.

### Upload to Proxmox

Upload the recovered ISO files to Proxmox and change the name in the Packer settings file. Each version of Windows has its own settings file.

### Prepare config.auto.pkrvars.hcl

Now go to /packer/packer-windows/ and modify the config.auto.pkrvars.hcl template file
```
cd /packer/packer-windows/
cp config.auto.pkrvars.hcl.template config.auto.pkrvars.hcl
```
The config.auto.pkrvars.hcl file will contain all the informations needed by packer to contact the proxmox api
```
proxmox_url             = "https://proxmox:8006/api2/json"
proxmox_username        = "user"
proxmox_token           = "changeme"
proxmox_skip_tls_verify = "true"
proxmox_node            = "mynode"
proxmox_pool            = "mypool"
proxmox_storage         = "local"
```
### Start ISO generation
```
./build_proxmox_iso.sh
```
### Upload the ISOs

We need to upload on Proxmox the additional tools with the freshly generated ISOs.

We can do it from the Web Interface or SCP via SSH.

We need to also add the drivers located in the virtio-win.iso. We can download it here :

https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/virtio-win-0.1.240-1/

## Build Image Template

### Windows Server 2019 Example

The variables are located in this files /packer/packer-windows/windows-server2019_proxmox_cloudinit.pkvars.hcl :
```
winrm_username        = "vagrant"
winrm_password        = "vagrant"
vm_name               = "WinServer2019x64-cloudinit-raw"
template_description  = "Windows Server 2019 64-bit - template built with Packer - cloudinit - {{isotime \"2006-01-02 03:04:05\"}}"
iso_file              = "local:iso/fr-fr_windows_server_2019_updated_aug_2021_x64_dvd_b863695e.iso"
autounattend_iso      = "./iso/Autounattend_winserver2019_cloudinit.iso"
autounattend_checksum = "sha256:3247ca9ffacb61627dddfde32d54d7ddba0af2ab62697fa5f94dd0b1bd56a5da"
vm_cpu_cores          = "2"
vm_memory             = "4096"
vm_disk_size          = "40G"
vm_sockets            = "1"
os                    = "win10"
```
Launch the generation with these commands :
```
packer init .
packer validate -var-file=windows_server2019_proxmox_cloudinit.pkvars.hcl .
packer build -var-file=windows_server2019_proxmox_cloudinit.pkvars.hcl .
```
### Other OS

Same as Windows 2019 !!!

## References

  * https://mayfly277.github.io/posts/GOAD-on-proxmox-part2-packer/
  * https://github.com/Orange-Cyberdefense/GOAD