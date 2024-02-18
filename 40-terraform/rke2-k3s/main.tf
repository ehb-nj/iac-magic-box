terraform {
  #backend "remote" {
  #  organization = "your terraform cloud org"

  # token = "your token here"

  #  workspaces {
  #    name = "your terraform workspace name here"
  #  }
  #}

  backend "local" {
    path = "terraform.tfstate"
  }

  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = ">=0.40.0"
    }
  }
}
