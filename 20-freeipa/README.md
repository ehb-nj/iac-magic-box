# FreeIPA

We are going to use a LXC Container based on AlmaLinux. You can add a template of your LXC from `node` ⇒ `local` ⇒ `CT Templates` ⇒ `Templates`.

## Prerequisites

- PVE deployment
- RPM based cloud image
- RPM based distro notions

## Deploy the base image

The base OS needs to be a `Fedora / Redhat / CentOS / AlmaLinux / Rocky Linux`.

Minimum ressources :

- Memory : 2Gb
- CPU : 1
- Network : 172.16.0.10/24 - Gateway : 172.16.0.1

You need to deploy your image with at least a temporary root password for adding `openssh-server` package manually.

```
dnf install -y openssh-server
systemctl enable sshd
systemctl start sshd
```
Now after you change your root password for something more secure you can connect with your SSH key.

## FreeIPA

(We follow the official documentation, FreeIPA is not really difficult to install).

Normally when you install your LXC container a new line is added automatically in your `/etc/hosts` file.

### Install FreeIPA server.

From a root terminal, run:
`dnf install freeipa-server`. Note that the installed package just contains all the bits that FreeIPA uses, it does not configure the actual server. If you want to include the DNS server also install the `freeipa-server-dns` package.

We don't need DNS package this one is handle by DNSMasq on OpenWRT.

### Configure a FreeIPA server.

The command can take arguments or can be run in the interactive mode. You can get more details with `man ipa-server-install`. To start the interactive installation, run: `ipa-server-install --no-ntp`. The command will at first gather all required information and then configure all required services.

### Variables of the installation (correct by default)
```
The IPA Master Server will be configured with:
Hostname:       ipa.play.lan
IP address(es): 172.16.0.10
Domain name:    play.lan
Realm name:     PLAY.LAN

The CA will be configured with:
Subject DN:   CN=Certificate Authority,O=PLAY.LAN
Subject base: O=PLAY.LAN
Chaining:     self-signed

Continue to configure the system with these values? [no]: yes
```
### End of the installation
```
Setup complete

Next steps:
	1. You must make sure these network ports are open:
		TCP Ports:
		  * 80, 443: HTTP/HTTPS
		  * 389, 636: LDAP/LDAPS
		  * 88, 464: kerberos
		UDP Ports:
		  * 88, 464: kerberos
		  * 123: ntp

	2. You can now obtain a kerberos ticket using the command: 'kinit admin'
	   This ticket will allow you to use the IPA tools (e.g., ipa user-add)
	   and the web user interface.

Be sure to back up the CA certificates stored in /root/cacert.p12
These files are required to create replicas. The password for these
files is the Directory Manager password
The ipa-server-install command was successful
```
## References

  * https://www.freeipa.org/page/Quick_Start_Guide
  * https://bamhm182.notion.site/Keycloak-Mariadb-and-OpenLDAP-d1587c81353c42e598526cae9c8f5efd



