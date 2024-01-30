# todos

## ansible
- make fog playbook fully automated using [cli args](https://docs.fogproject.org/en/latest/installation/server/command-line-options/#fog-installer-command-line-options)

## terraform
- reorder tags alphabetically and add `qemu_os = "l26"` to avoid unnecessary changes
- structure terraform better with help from [this article](https://12ft.io/proxy?q=https%3A%2F%2Fmedium.com%2Fcodex%2Fterraform-best-practices-limit-resources-in-your-project-a3f3275f7bbf)

## proxmox
- use ansible to add letsencrypt certificates to proxmox cluster
- configure haproxy on router to have a single endpoint for proxmox cluster
- make non-k3s VMs HA

## k3s
- switch to cilium
- disable servicelb and traefik
- install metallb and ingress-nginx
- add longhorn by making 100gb disks on the 2tb drives per k3s vm
- add [system-upgrade-controller](https://github.com/rancher/system-upgrade-controller)
- start using flux again but with gitlab
- add renovatebot to repo to update images

## other
- try out librenms instead of observium
- add influxdb in vm for proxmox metrics
- add prometheus in vm for other stuff
- add grafana in vm and connect to above
- add gitlab runners
- add github runners
- add docker buildx remote builders
