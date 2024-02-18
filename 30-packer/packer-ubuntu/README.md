# Packer for Ubuntu 22.04

## Devops environment preparation

Install needed components into your computer, Packer from Hashicorp :

### MacOS

```bash
brew tap hashicorp/tap
brew update
brew install hashicorp/tap/packer
```

### Debian & Ubuntu

```bash
sudo apt update
sudo apt -y install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt update
sudo apt install packer
```

## Proxmox preparation

You need to create the "Templates" pool on your Proxmox (Datacenter->Permissions->Pools). Also, upload the Ubuntu 22.04 official ISO into your local storage. The ISO name must bu changed in the packer vars file.

### Dedicated user for Packer

```bash
pveum useradd infra_as_code@pve
pveum passwd infra_as_code@pve
# Role Packer Creation
pveum roleadd Packer -privs "VM.Config.Disk VM.Config.CPU VM.Config.Memory Datastore.AllocateTemplate Datastore.Audit Datastore.AllocateSpace Sys.Modify VM.Config.Options VM.Allocate VM.Audit VM.Console VM.Config.CDROM VM.Config.Cloudinit VM.Config.Network VM.PowerMgmt VM.Config.HWType VM.Monitor SDN.Use"
# Role attribution
pveum acl modify / -user 'infra_as_code@pve' -role Packer
```


## Build image template

Ubuntu 22.04 will be installed automatically with its cloud-init file, `user-data`. You must change some values inside to match your needs. Some packages are installed (ca-certificates, cloud-init, qemu-guest-agent, sudo) during the installation to facilitate the integration.

You need a connection between the image created and the machine from which you are running Packer (defaut port to open is between 8000 and 8200, you can adjust them on the variables file).

Copy the variable example file :

```bash
cp ubuntu.pkvars.hcl.example ubuntu.pkvars.hcl 
```

Variables for packer are located in the file `ubuntu.pkvars.hcl`. You must adjust them to your environment and your needs.

Launch the generation with these commands :

```bash
packer init .
packer validate -var-file=ubuntu.pkrvars.hcl .
packer build -var-file=ubuntu.pkrvars.hcl .
```
