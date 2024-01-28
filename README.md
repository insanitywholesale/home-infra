# infra
repository for my home infra using infrastructure as code

## things in here
explanation of main directories

- the active ones:
	* `kube` includes kubernetes yaml manifests as well as Helm values.yaml configs
	* `terraform` includes terraform configuration to create virtual machines from templates
	* `ansible` includes ansible automation being built for configuring the proxmox hosts as well as the virtual machines created with terraform
	
- the archive ones:
	* `unused/vagrant` has some basic examples for how to write a Vagrantfile
	* `unused/raw-libvirt` is the older version of the terraform+proxmox setup but with libvirt instead of proxmox for virtualization
	* `unused/kube` mirrors the layout of `kube` but has unused things stored as examples
	* `unused/reverse-proxy-config/traefik` old unified single traefik VM instance
	* `unused/terraform` includes the `proxmox-single` subdirectory that includes old ansible and terraform configuration for a non-cluster multi-node proxmox setup

# services
services I run and want to run

the ones with the IPs fully written out are up and running right now

## Fundamentals
NTP, DNS, PXE, FTP and APT cache.

### NTP
.1

### Pi-hole
.2

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
.14

### Vaultwarden
.15

### Vault
.16

### Keycloak
.17

### Authelia
.18

## Databases and Message Queues
Databases and message queues for applications.

### PostgreSQL
.20

### MySQL
.21

### MongoDB
.22

### CouchDB
.23

### Redis
.24

### RabbitMQ
.25

### Kafka
.26

### OpenSearch
.27

### TimescaleDB
.28

### InfluxDB
.29

## Monitoring
Tools for monitoring, logging, tracing and data visualization.

### syslog
.30

### Prometheus + Grafana + Loki
.31

### Observium or LibreNMS
.32

### Zabbix
.33

### Graylog
.34

### NetBox
.35

### ntfy
.36

### Gatus or Uptime Kuma
.37

### Sentry
.38

### Jaeger Clickhouse
.39

### Hydras.io or Rudderstack
.40

## Code-related infrastrucutre
Code analysis and git hosting plus container registry and helm repo.

### Sonarqube or Deepsource
.43

### Codecov
.44

### GitLab
.45

### Harbor
.48

### Chartmuseum
.49

## Kubernetes
Kubernetes nodes

### k3s ingress
10.0.50.50

### k3s control plane nodes
10.0.50.51-53

### k3s worker nodes
10.0.50.61-64

### k3s single-node cluster
.69

## Physical servers
Bare-metal machines where most things run on

## Proxmox
10.0.50.70-72 (leave space for up to .75)

## TrueNAS
10.0.50.100

## Backup
.101

## Non-clusterful applications
Can't or don't want to run these on kubernetes.

## HomeAssistant
.102

## Jellyfin
.105
