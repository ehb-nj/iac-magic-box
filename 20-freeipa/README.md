# FreeIPA

We are going to use a VM based on Fedora 39. The cloud-init image is built in this section : `proxmox/linux-templates`.

## Prerequisites

- PVE deployment
- RPM based cloud image
- RPM based distro notions

## Deploy the base image

The base OS needs to be a `Fedora / Redhat / CentOS / AlmaLinux / Rocky Linux`.

We are going to test with a Fedora 39 Cloud version with cloud-init.

## FreeIPA

(We follow the official documentation, FreeIPA is not really difficult to install).

Kerberos authentication relies on a static hostname, if the hostname changes, Kerberos authentication may break. Thus, the testing machine should not use dynamically configured hostname from DHCP, but rather a static one configured in `/etc/hostname`.

With cloud-init we need to remove the domain name inserted for localhost/127.0.0.1, and replace it with the real IP and "ipa.play.lan".

```
# The following lines are desirable for IPv4 capable hosts
127.0.0.1 localhost.localdomain localhost
127.0.0.1 localhost4.localdomain4 localhost4

# The following lines are desirable for IPv6 capable hosts
::1 localhost.localdomain localhost
::1 localhost6.localdomain6 localhost6

172.16.0.10 ipa.play.lan ipa
```
### Install FreeIPA server.

From a root terminal, run:
`dnf install freeipa-server`. Note that the installed package just contains all the bits that FreeIPA uses, it does not configure the actual server. If you want to include the DNS server also install the `freeipa-server-dns` package.

We don't need DNS package this one is handle by DNSMasq on OpenWRT.

### Configure a FreeIPA server.

The command can take arguments or can be run in the interactive mode. You can get more details with `man ipa-server-install`. To start the interactive installation, run: `ipa-server-install`. The command will at first gather all required information and then configure all required services.

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



