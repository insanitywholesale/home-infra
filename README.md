# infra
repository for my home infra using infrastructure as code

## things in here
explanation of main directories

- the 3 main ones:
	- `ansible` includes ansible automation being built for configuring the proxmox hosts as well as the virtual machines created with terraform
	- `terraform` includes terraform configuration to create virtual machines from templates
	- `fluxcd` includes fluxcd configuration to automatically deploy applications to a kubernetes cluster

# Services
List of services I currently run or want to run in the future.

The ones with the IPs fully written out are configured and running right now.

## Fundamentals
NTP, DNS, PXE, FTP and APT cache.

### NTP
.1

### Pi-hole
10.0.50.2

### AdGuard Home
.3

### LANcache
.4

### BIND9 (external-dns RFC2136 provider)
.5

### CoreDNS (`k8s_gateway` plugin)
.6

### matchbox
.7

### netboot.xyz
.8

### apt-cacher-ng
10.0.50.9

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

### Authelia or Authentik
.18

### Smallstep CA
10.0.50.19

## Databases and Message Queues
Databases and message queues for applications.

### PostgreSQL
10.0.50.20

### MySQL
10.0.50.21

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

### Logstash
.28

### Clickhouse
.29

## Monitoring
Tools for monitoring, logging, tracing and data visualization.

### Grafana
10.0.50.30

### Prometheus + Alertmanager
10.0.50.31

### InfluxDB
10.0.50.32

### Observium
10.0.50.34

### Graylog
.35

### Gatus or Uptime Kuma
.37

### Sentry
10.0.50.38

### rsyslog or syslog-ng
.39

## Code-related infrastrucutre
Code analysis and git hosting plus container registry and helm repo.

### Nexus
.40

### Harbor
.41

### Chartmuseum
.42

### Sonarqube or Deepsource
.43

### Codecov
.44

### GitLab
10.0.50.45

### Gitea
.46

## Kubernetes
Kubernetes nodes

### k3s main cluster loadbalanced API server
.50

### k3s control plane nodes
10.0.50.51-53

### k3s secondary cluster loadbalanced API server
.60

### k3s worker nodes
10.0.50.61-69

## Physical servers
Bare-metal machines where most things run on

### Proxmox
10.0.50.70-72 (leave space for up to .75)

### TrueNAS
10.0.50.100

### Backup
10.0.50.101

## Non-clusterful applications
Can't or don't want to run these on kubernetes.

### Generic web server
.110

### Web server for local downloads/caching
.111

### NetBox
10.0.50.112

### HomeAssistant
.113

### ntfy
.114

### Jellyfin
.115

### Deluge
10.0.50.116

### Archivebox
.117

### k3s main cluster ingress
.150

### k3s main cluster metallb pool
.150-199

### cloudflared
.201
