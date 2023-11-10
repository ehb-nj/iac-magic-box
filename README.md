# iac-magic-box
A toolbox for creating IaC on Proxmox

## Goal

The aim of this project is to provide the glue needed to build a beginning of Cloud and IaC on the Proxmox hypervisor. Evolutions will be planned to potentially support other hypervisors, but for now we're choosing the path of freedom.

Many projects already exist on this theme, and we'll credit them all as references. However, few clearly explain the path to a ready-to-use environment for designing I.S. and services in "code" form.

It may be a long road, but it's already begun.

## Vault

We need a way to manage secrets and certificates.
This part will be gradually integrated into the final project.

## Packer

The first step is to create the images needed to offer the VPS service. This part provides the minimum OS to support the services to be deployed. In the case of laboratories, these images can also be used to test and emulate a complete Information System.

Different steps and prerequisites are required to make this part work. Each Packer subfolder contains documentation relating to its part.

## Terraform

The Terraform part is left up to users to deploy their own services and I.S. as they see fit. However, examples will be provided. 
For a complete Cloud, a method for setting up a complete RKE2 will also be provided. This RKE2 will be managed by Rancher and preinstalled with Neuvector.

## RKE2

RKE2 is chosen by default for the Kubernetes part, as it is complete and secure.