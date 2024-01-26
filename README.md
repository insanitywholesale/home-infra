# infra

infrastructure-related things I'm testing/working on including automating my homelab

## things in here
there are a few top-level directories here.
- the active ones:
	* `kube` includes kubernetes yaml manifests as well as Helm values.yaml configs
	* `terraform/proxmox` includes terraform configuration as well as ansible playbooks for k3s
- the archive ones:
	* `unused/vagrant` has some basic examples for how to write a Vagrantfile
	* `unused/raw-libvirt` is the older version of the terraform+proxmox setup but with libvirt instead of proxmox for virtualization
	* `unused/kube` mirrors the layout of `kube` but has unused things stored as examples
	* `unused/reverse-proxy-config/traefik` old unified single traefik VM instance

# Services
Services I run and want to run.
Only the ones will the IPs fully written out are up and running right now.

## Fundamentals
NTP, DNS, PXE, FTP and package cache.

### NTP
.1

### Pi-hole
10.0.50.2

### LANcache
.3

### Bind9 (external-dns RFC2136 provider)
.4

### PowerDNS (external-dns pdns provider)
.5

### CoreDNS (`k8s_gateway` plugin)
.6

### FOG
.7

### Tinkerbell
.8

### apt-cacher-ng
.9

## Identity, Secrets and Passwords
System and app auth, passwords for people and secrets for apps.

### Active Directory
.10

### FreeIPA main
.11

### FreeIPA backup
.12

### LLDAP
.13

### FreeRADIUS
