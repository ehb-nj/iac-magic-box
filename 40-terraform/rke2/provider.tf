### Provider configuration ###

provider "proxmox" {
  endpoint = "${local.proxmox_data.proxmox_url}"
  api_token = "${local.proxmox_data.tokenid}"
  ssh {
    agent    = true
    username = "root"
  }
}

provider "vault" {}