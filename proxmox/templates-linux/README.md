# Linux templates

Here is some Linux templates examples on Proxmox. I's the quickest way and the "best way" to do it.

> [!NOTE]
> Some bash script will be developped

## Prerequisites

The "Templates" ressource pool must be present on PVE.
Internet access on the network we will prepare the images (for applying the upgrades).

## Debian Bookworm (12.2)

We're going to create a template based on a Debian image dedicated to the cloud.

```
wget https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-genericcloud-amd64.qcow2
```

Next, we need to import the recovered file so that Proxmox can manage it and create a template. My proxmox is configured with LVM volumes whose mount point is the default name: local-lvm

Creating a virtual machine (we choose 9000 for the ID - need to be change if you already have this on on your PVE) :
```
qm create 9000 --name debian12x64-cloudinit-raw --memory 2048 --net0 virtio,bridge=vmbr0 --sockets 1 --cpu cputype=kvm64 --pool Templates
```

Cloud-Init requires the use of a serial console :
```
qm set 9000 --serial0 socket --vga serial0
```
We import the .qcow2 file to make a disk:
```
qm importdisk 9000 debian-12-genericcloud-amd64.qcow2 local-lvm
```
Attach the disk to the virtual machine:
```
qm set 9000 --scsihw virtio-scsi-pci --scsi0 local-lvm:vm-9000-disk-0
qm set 9000 --boot c --bootdisk scsi0
```

If you want to increase the disk size, the default is 2G for the image I retrieved. Let's increase it by 18G, so it will be a 20G disk:
```
qm resize 9000 scsi0 +18G
```

We add the volume dedicated to Cloud-Init:
```
qm set 9000 --ide2 local-lvm:cloudinit
```

Template creation :
```
qm template 9000
```

Delete qcow image :
```
rm debian-12-genericcloud-amd64.qcow2
```

## Ubuntu 22.04.3 LTS (Jammy Jellyfish)

Quick version (we choose 9001 for the ID - need to be randomly change if you already have this on on your PVE) :

```
wget https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64-disk-kvm.img
qm create 9001 --name ubuntu2204LTSx64-cloudinit-raw --memory 2048 --net0 virtio,bridge=vmbr0 --sockets 1 --cpu cputype=kvm64 --pool Templates
qm set 9001 --serial0 socket --vga serial0
qm importdisk 9001 jammy-server-cloudimg-amd64-disk-kvm.img local-lvm
qm set 9001 --scsihw virtio-scsi-pci --scsi0 local-lvm:vm-9001-disk-0
qm set 9001 --boot c --bootdisk scsi0
qm resize 9001 scsi0 +18G
qm set 9001 --ide2 local-lvm:cloudinit
qm template 9001
```
