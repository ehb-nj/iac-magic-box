# RKE2 Cluster

## Prerequisites 

- Vault available from the host where terraform is launched
- Some Kubernetes knowledge
- Debian based image template (Ubuntu Recommended) available
- Terraform installed on the "admin machine"
- Proxmox deployed and installed

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
### Vault secrets preparation

The token id has this form : `user@pve!token_name=password`

You can create this token directly from the PVE Web Interface. `Datacenter` -> `Permissions` -> `API Tokens`

In my example I've taken the `infra_as_code` user created in the `30-packer` section.

```
vault secrets enable -path=secrets/terraform kv
vault kv put secrets/terraform/proxmox tokenid="xxx" proxmox_url="xxx"
vault kv put secrets/terraform/ssh public_key="xxxx"
```
### Terraform preparation

Copy the env.tfvars.example to env.tfvars :
```
cp env.tfvars.example env.tfvars
```
Modify the variables to match your environment.

### Launching the magic

The RK2 environment is installed with these commands :
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

```
brew install kubectl (on MacOS)

(on Other Linux OS)
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin
```
You need to copy the `/etc/rancher/rke2/rke2.yaml` (from the master-0) to you local machine (`~/.kube/config`).  And change the IP adress to `172.16.2.20`.
```
kubectl get nodes

NAME           STATUS   ROLES                       AGE   VERSION
rke-master-0   Ready    control-plane,etcd,master   25m   v1.26.11+rke2r1
rke-worker-0   Ready    <none>                      25m   v1.26.11+rke2r1
rke-worker-1   Ready    <none>                      25m   v1.26.11+rke2r1
```

## References

https://github.com/torquemada163/proxmox-terraform-k8s-rke2/blob/main/README.md