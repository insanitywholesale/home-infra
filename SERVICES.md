# Services
List of services I currently run or want to run in the future.

The ones with the IPs fully written out are configured and running right now.

## Fundamentals
NTP, DNS, PXE and such.

### NTP (exact software TBD)
.1

### Pi-hole
10.0.50.2

### AdGuard Home
.3

### LANcache
.4

### CoreDNS (`k8s_gateway` plugin)
.6

### PXE (to be determined)
.7

## Identity, Secrets and Passwords
Authentication, authorization and secrets.

### SMB4 DC
.10

### FreeIPA main
.11

### FreeIPA backup
.12

### LLDAP
.13

### FreeRADIUS
.14

### Keycloak
10.0.50.15

### Authelia
.16

### Authentik
.17

### Vault
.18

### Smallstep CA
10.0.50.19

## Data places
Databases, Kafka, Opensearch

### PostgreSQL
10.0.50.20 (reserved up to .22 for cluster)

### MySQL
10.0.50.23

### Kafka
.24-6

### OpenSearch
.27-9

## Monitoring
Tools for monitoring, logging, tracing and data visualization.

### Grafana
10.0.50.30

### Prometheus + Alertmanager
10.0.50.31

### InfluxDB
10.0.50.32

### Graphite
.33

### LibreNMS
.34

### Graylog
.35

### Gatus
.36

### Uptime Kuma
.37

### GlitchTip
.38

## Code-related infrastrucutre
Code analysis and git hosting plus container registry and helm repo.

### Nexus
.40

### Harbor
.41

### Chartmuseum
.42

### GitLab
10.0.50.45

### Forgejo
.46

### Sonarqube
.47

### Deepsource
.48

### Codecov
.49

## Kubernetes
Kubernetes nodes

### k3s main cluster loadbalanced API server
.50

### k3s control plane nodes
10.0.50.51-53

### blank for now, potentially new ingress controller address
.60

### k3s worker nodes
10.0.50.61-63

## Physical servers
Bare-metal machines where most things run on

### Proxmox loadbalanced endpoint
10.0.50.70

### Proxmox
10.0.50.71-73 (leave space for up to .75)

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

### Torrent client (to be determined)
.116

### Archivebox
.117

### Vaultwarden
.118

### Rudderstack
.119

### Github actions runner
.140

### Docker buildx
10.0.50.141-142

### Gitlab runners
10.0.50.143-145

### k3s main cluster metallb pool
10.0.50.150-199

### cloudflared
10.0.50.201

### Tailscale
.202
