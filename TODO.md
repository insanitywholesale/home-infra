# todos

## ansible
- add postgres backup using [pgbackrest](https://bun.uptrace.dev/postgres/pgbackrest-s3-backups.html)
- add certbot tasks adapted from postgres to [configure TLS for influxdb](https://docs.influxdata.com/influxdb/v2/admin/security/enable-tls/#configure-influxdb-to-use-tls)
- configure grafana to connect to influxdb and prometheus
- finish librenms playbook

## terraform
- structure terraform better with help from [this article](https://12ft.io/proxy?q=https%3A%2F%2Fmedium.com%2Fcodex%2Fterraform-best-practices-limit-resources-in-your-project-a3f3275f7bbf)

## proxmox
- use ansible to add letsencrypt certificates to proxmox cluster
- configure haproxy on router to have a single endpoint for proxmox cluster
- make non-k3s VMs HA

## k3s
- improve metallb and ingress-nginx installation procedure
- switch to cilium from flannel
- install more things using fluxcd
- add longhorn by making 100gb disks on the 2tb drives per k3s vm
- add [system-upgrade-controller](https://github.com/rancher/system-upgrade-controller)
- add renovatebot to repo to update images

## other
- add gitlab runners
- add github runners
- add docker buildx remote builders
