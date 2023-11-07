packer {
  required_plugins {
    proxmox = {
      version = "1.1.5"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

source "proxmox-iso" "debian12_node" {
  proxmox_url              = var.node_url
  username                 = var.node_username
  password                 = var.node_password
  insecure_skip_tls_verify = true
  node                     = var.node

  vm_name                 = var.vm_name
  template_description    = "Debian 12 Booksworm Packer Template -- Created: ${formatdate("YYYY-MM-DD hh:mm:ss ZZZ", timestamp())}"
  vm_id                   = var.vm_id
  os                      = "l26"
  cpu_type                = var.type_cpu
  sockets                 = var.nb_cpu
  cores                   = var.nb_core
  memory                  = var.nb_ram
  machine                 = "q35"
  bios                    = "seabios"
  scsi_controller         = "virtio-scsi-pci"
  qemu_agent              = true

  network_adapters {
    bridge   = var.bridge
    firewall = true
    model    = "virtio"
  }

  disks {
    disk_size         = var.disk_size
    format            = var.disk_format
    storage_pool      = var.storage_pool
    type              = "scsi"
  }
  efi_config {
    efi_storage_pool  = var.storage_pool
    efi_type          = "4m"
    pre_enrolled_keys = true
  }

  iso_url           = "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.2.0-amd64-netinst.iso"
  iso_checksum      = "23ab444503069d9ef681e3028016250289a33cc7bab079259b73100daee0af66"
  iso_download_pve  = true
  iso_storage_pool  = var.iso_storage_pool
  unmount_iso       = true

  http_directory = "http"
  http_port_min  = 8100
  http_port_max  = 8100
  boot_wait      = "10s"
  boot_command   = ["<esc><wait>auto console-keymaps-at/keymap=fr console-setup/ask_detect=false debconf/frontend=noninteractive fb=false url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg<enter>"]

  ssh_username = var.ssh_username
  ssh_password = var.sudo_password
  ssh_timeout  = "20m"
}

build {
  sources = ["proxmox-iso.debian12_node"]
}
