# RKE2/K3S Cluster

## Prerequisites

For small CPU/RAM footprint prefer the K3S deployment

- Vault available from the host where terraform is launched
- Some Kubernetes knowledge
- Debian based image template (Ubuntu Recommended) available
- Terraform installed on the "admin machine"
- Proxmox deployed and ready with snippets (for cloud-init) activated
- Network for Kube ready with Internet connection
- Network configured and flow configured to access PVE node and Kube nodes
- SSH-Agent configured (use to deploy snippets for cloud-init)

## Terraform

### Installation

MacOS :
```
brew install terraform
```
Ubuntu :
```
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
gpg --no-default-keyring \
--keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
--fingerprint
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update
sudo apt-get install terraform
```
### SSH-Agent

SSH is needed to upload ressources to the snippet repository (by default our ssh key is used):

```
ssh-add ~/.ssh/id_rsa
```

### Vault secrets preparation

The token id has this form : `user@pve!token_name=password`

You can create this token directly from the PVE Web Interface. `Datacenter` -> `Permissions` -> `API Tokens`

Or use cmd line on PVE :
```
pveum user token add "infra_as_code@pve" "terraform" --privsep 0

┌──────────────┬──────────────────────────────────────┐
│ key          │ value                                │
╞══════════════╪══════════════════════════════════════╡
│ full-tokenid │ infra_as_code@pve!terraform          │
├──────────────┼──────────────────────────────────────┤
│ info         │ {"privsep":"0"}                      │
├──────────────┼──────────────────────────────────────┤
│ value        │ 6052e2dc-a66c-4434-806a-f0a1179bf10e │
└──────────────┴──────────────────────────────────────┘

```

In my example I've taken the `infra_as_code` user created in the `30-packer` section.

Need to add `Pool.Audit`, `Pool.Allocate`, `Datastore.Allocate`, `VM.Allocate` (On PVE):
```
pveum role modify Packer -privs "VM.Config.Disk VM.Config.CPU VM.Config.Memory Datastore.AllocateTemplate Datastore.Audit Datastore.AllocateSpace Sys.Modify VM.Config.Options VM.Allocate VM.Audit VM.Console VM.Config.CDROM VM.Config.Cloudinit VM.Config.Network VM.PowerMgmt VM.Config.HWType VM.Monitor SDN.Use Pool.Audit Pool.Allocate Datastore.Allocate VM.Clone"
```
Create secrets in Vault :
```
vault secrets enable -path=secrets/terraform kv
vault kv put secrets/terraform/proxmox tokenid='xxx' proxmox_url="xxx"
vault kv put secrets/terraform/ssh public_key="xxxx"
```
### Terraform preparation

Copy the env.tfvars.example to env.tfvars :
```
cp env.tfvars.example env.tfvars
```
Modify the variables to match your environment. Change the Kubernetes deployment type with this variable : `kubernetes = "rke2" # rke2 or k3s`

### Launching the magic

The RK2 environment is prepared and installed with these commands :
```
terraform init
terraform plan -var-file env.tfvars
terraform apply -var-file env.tfvars
```
Adn destroyed with this command :
```
terraform destroy -var-file env.tfvars
```
## Testing RKE2

You need to install `kubectl`
MacOS :
```
brew install kubectl (on MacOS)
```
Other Linux OS :
```
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin
```
You need to copy the `/etc/rancher/rke2/rke2.yaml` (from the rke-master-01) to you local machine (`~/.kube/config`).  And change the IP adress to the corresponding `rke-master-01`.
```
kubectl get nodes

NAME           STATUS   ROLES                       AGE   VERSION
rke-master-01   Ready    control-plane,etcd,master   25m   v1.26.11+rke2r1
rke-worker-01   Ready    <none>                      25m   v1.26.11+rke2r1
rke-worker-02   Ready    <none>                      25m   v1.26.11+rke2r1
```

## References

https://github.com/torquemada163/proxmox-terraform-k8s-rke2/blob/main/README.md