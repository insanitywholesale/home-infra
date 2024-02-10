# todos

## ansible
- add postgres backup using [pgbackrest](https://bun.uptrace.dev/postgres/pgbackrest-s3-backups.html)
- add certbot tasks adapted from postgres to [configure TLS for influxdb](https://docs.influxdata.com/influxdb/v2/admin/security/enable-tls/#configure-influxdb-to-use-tls)
- configure grafana to connect to influxdb and prometheus
- extend gitlab playbook accordign to [next steps](https://docs.gitlab.com/ee/install/next_steps.html)
- extend gitlab playbook by configuring [HTTPS manually](https://docs.gitlab.com/omnibus/settings/ssl/index.html#configure-https-manually)
- add certbot tasks adapted from postgres to configure TLS for mysql
- add step-ca playbook based on [this collection](https://github.com/maxhoesel-ansible/ansible-collection-smallstep)
- add nexus playbook based on [this role](https://github.com/ansible-ThoTeam/nexus3-oss)
- add keycloak playbook based on [this post](https://developers.redhat.com/articles/2023/02/20/automate-your-sso-ansible-and-keycloak) and [this post](https://developers.redhat.com/articles/2022/04/20/deploy-keycloak-single-sign-ansible) and using [this collection](https://github.com/ansible-middleware/keycloak)

## terraform
- structure terraform better with help from [this article](https://12ft.io/proxy?q=https%3A%2F%2Fmedium.com%2Fcodex%2Fterraform-best-practices-limit-resources-in-your-project-a3f3275f7bbf)
- create windows template with help from [this blog post](https://yetiops.net/posts/proxmox-terraform-cloudinit-windows/)

## proxmox
- use ansible to add letsencrypt certificates to proxmox cluster
- configure haproxy on router to have a single endpoint for proxmox cluster according to the following
	* https://pve.proxmox.com/wiki/Web_Interface_Via_Nginx_Proxy
	* https://www.armand.nz/notes/ProxMox/Installing%20Nginx%20as%20a%20reverse%20proxy%20for%20your%20Proxmox%20Web%20interface
	* https://forum.proxmox.com/threads/using-nginx-as-reverse-proxy-externally.116127/
- make non-k3s VMs HA
- enable ceph s3 using the following sources
	* https://web.archive.org/web/20190721212730/https://dragontek.com/blog/post/adding-s3-capabilities-proxmox
	* https://base64.co.za/enable-amazon-s3-interface-for-ceph-inside-proxmox/
	* https://forum.proxmox.com/threads/trying-to-setup-ceph-radosgw-for-s3-entry.131788/

## k3s
- improve metallb and ingress-nginx installation procedure
- switch to cilium from flannel
- install more things using fluxcd
- add longhorn by making 100gb disks on the 2tb drives per k3s vm
- add [system-upgrade-controller](https://github.com/rancher/system-upgrade-controller)
- add renovatebot to repo to update images
- look into [Cluster API Provider for Proxmox](https://github.com/ionos-cloud/cluster-api-provider-proxmox)

## other
- add gitlab runners
- add github runners
- add docker buildx remote builders
