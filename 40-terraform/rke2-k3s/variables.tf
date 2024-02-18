### Vault

data "vault_generic_secret" "secrets_proxmox" {
  path = "secrets/terraform/proxmox"
}

data "vault_generic_secret" "secret_ssh" {
  path = "secrets/terraform/ssh"
}

variable "vmdata" {}

locals {
  proxmox_data = jsondecode(data.vault_generic_secret.secrets_proxmox.data_json)
  ssh_data = jsondecode(data.vault_generic_secret.secret_ssh.data_json)
}

resource "random_password" "kube_token" {
  length           = 30
  special          = false
}