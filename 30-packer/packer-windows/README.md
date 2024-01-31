# Packer Windows

The aim of this section is to build Windows images that can be cloned with Terraform.

## Requirements

- Packer on the "admin machine"
- Vault on the "admin machine"
- ISOs of the operating systems
- Mkisofs

Create the templates in a Network with DHCP available and Internet connexion for Windows Updates.

We need to have an HTTPS connexion from your machine to the Proxmox server. You also need WINRM connexion between the templates created (2 TCP ports need to be opened : 5985, 5986).

You need to create the "Templates" pool on your Proxmox (Datacenter->Permissions->Pools).

### MacOS

```bash
brew tap hashicorp/tap
brew install hashicorp/tap/packer
brew install dvdrtools
```

### Ubuntu

```bash
sudo apt update
sudo apt -y install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt update
sudo apt install packer
sudo apt install mkisofs
```

### Cloudbase-Init

Cloudbase-Init is the Windows version of Cloud-Init.
Download here : <https://cloudbase.it/cloudbase-init/>
Put the msi here (and rename it) :

```bash
30-packer/packer-windows/sysprep/CloudbaseInitSetup_Stable_x64.msi
```

## Build ISO images

### Download the ISOs

You need to download Windows ISOs. By default, autounattend scripts use the French version of Windows images. If you need to modify the language parameters, you must do so in each Autounattend.xml script in the answer_file directory.

We also need the virtio drivers. The iso must be uploaded via the Web Interface (or scp). The name of this iso file must be changed on the `virtio_iso` variable on the corresponding "pkvars.hcl" file.

### Upload to Proxmox

Upload the recovered ISO files to Proxmox and change the name in the Packer settings file. Each version of Windows has its own settings file.

### Dedicated user for Packer

```bash
pveum useradd infra_as_code@pve
pveum passwd infra_as_code
# Role Packer Creation
pveum roleadd Packer -privs "VM.Config.Disk VM.Config.CPU VM.Config.Memory Datastore.AllocateTemplate Datastore.Audit Datastore.AllocateSpace Sys.Modify VM.Config.Options VM.Allocate VM.Audit VM.Console VM.Config.CDROM VM.Config.Cloudinit VM.Config.Network VM.PowerMgmt VM.Config.HWType VM.Monitor SDN.Use"
# Role attribution
pveum acl modify / -user 'infra_as_code@pve' -role Packer
```

### Prepare the secrets in Vault

Create policy "packer-windows-policy" :

```bash
vault policy write packer-windows-policy - << EOF
path "secrets/packer-windows/*" {
  capabilities = ["read"]
}
EOF
```

Affect this policy to a new token :

```bash
vault token create -ttl=1h -policy=packer-windows-policy
```

You need to create the environment variables `VAULT_ADDR`and the `VAULT_TOKEN`.

```bash
export VAULT_ADDR="https://vault.play.lan:8200"
export VAULT_TOKEN="hvs.xxxxxxxxxx....."
```

You need to create secrets in Vault.

```bash
vault kv create secrets/packer-windows
vault kv put secrets/packer-windows/proxmox \
proxmox_username="infra_as_code@pve" \
proxmox_url="https://pve.play.lan:8006/api2/json" \
proxmox_password="infra_as_code" \
proxmox_skip_tls_verify="true" \
proxmox_node="pve" proxmox_pool="Templates" \ proxmox_storage="local-lvm"
```

### Start ISO generation

```bash
./build_proxmox_iso.sh
```

## Build Image Template

### Windows Server 2019 Example

The variables are located in this files /packer/packer-windows/windows-server2019_proxmox_cloudinit.pkvars.hcl :

```hcl
autounattend_checksum = "sha256:7fc6411b8e19a13bb759bd5897a638cb5dad464099dc6108bfad7d8a4a0576bb"
autounattend_iso      = "./iso/Autounattend_winserver2019_cloudinit.iso"
iso_file              = "local:iso/fr-fr_windows_server_2019_updated_aug_2021_x64_dvd_b863695e.iso"
os                    = "win10"
scripts_checksum      = "sha256:8eeccc0aa7715970002c0ceaa70f205fc674f5916a4d264e5e2d11c178a1bd19"
scripts_iso           = "./iso/scripts_withcloudinit.iso"
template_description  = "Windows Server 2019 64-bit - template built with Packer - cloudinit - {{isotime \"2006-01-02 03:04:05\"}}"
virtio_iso            = "local:iso/virtio-win-0.1.240.iso"
vm_cpu_cores          = "2"
vm_disk_size          = "40G"
vm_memory             = "4096"
vm_name               = "WinServer2019x64-cloudinit-raw"
vm_sockets            = "1"
winrm_password        = "vagrant"
winrm_username        = "vagrant"

```

Launch the generation with these commands :

```bash
packer init .
packer validate -var-file=windows_server2019_proxmox_cloudinit.pkvars.hcl .
packer build -var-file=windows_server2019_proxmox_cloudinit.pkvars.hcl .
```

### Other Windows OS

Same as Windows 2019 !!!

## References

- <https://mayfly277.github.io/posts/GOAD-on-proxmox-part2-packer/>
- <https://github.com/Orange-Cyberdefense/GOAD>
