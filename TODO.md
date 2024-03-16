# todos
things to do

## ansible
- continue work on powerdns playbook using [this role](https://github.com/PowerDNS/pdns-ansible) and [this role](https://github.com/PowerDNS/pdns_recursor-ansible)
- add SSL certs to netbox
- add SSL certs to deluge
- add SSL certs to prometheus
- add SSL certs to grafana
- add nexus playbook based on [this role](https://github.com/ansible-ThoTeam/nexus3-oss)
- add gitlab-runner playbook based on [this role](https://github.com/riemers/ansible-gitlab-runner) and potentially [this module](https://docs.ansible.com/ansible/latest/collections/community/general/gitlab_runner_module.html)
- add github actions runner playbook based on [this role](https://github.com/MonolithProjects/ansible-github_actions_runner)
- add netbootxyz playbook based on [this role](https://github.com/netbootxyz/netboot.xyz/tree/2.0.77/roles/netbootxyz) that is already included and using vars files [endpoints.yml](https://github.com/netbootxyz/netboot.xyz/blob/2.0.77/endpoints.yml) and [user_overrides.yml](https://github.com/netbootxyz/netboot.xyz/blob/2.0.77/user_overrides.yml)
- configure grafana to connect to influxdb and prometheus
- extend step-ca playbook to generate certs based on [this collection](https://github.com/maxhoesel-ansible/ansible-collection-smallstep)
- extend gitlab playbook accordign to [next steps](https://docs.gitlab.com/ee/install/next_steps.html)
- add postgres backup using [pgbackrest](https://bun.uptrace.dev/postgres/pgbackrest-s3-backups.html)
- add graylog playbook based on [this role](https://github.com/Graylog2/graylog-ansible-role)
- add keycloak playbook based on [this post](https://developers.redhat.com/articles/2023/02/20/automate-your-sso-ansible-and-keycloak) and [this post](https://developers.redhat.com/articles/2022/04/20/deploy-keycloak-single-sign-ansible) and using [this collection](https://github.com/ansible-middleware/keycloak)

## terraform
- structure terraform better with help from [this article](https://12ft.io/proxy?q=https%3A%2F%2Fmedium.com%2Fcodex%2Fterraform-best-practices-limit-resources-in-your-project-a3f3275f7bbf)
- create windows template with help from [this blog post](https://yetiops.net/posts/proxmox-terraform-cloudinit-windows/) and [this blog post](https://blog.sunshower.io/2021/02/22/building-a-home-cloud-with-proxmox-dns-terraform/)

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
- add sentry-kubernetes to send errors to sentry using the following:
	* https://blog.sentry.io/surface-kubernetes-errors-with-sentry/
	* https://github.com/getsentry/sentry-kubernetes
	* https://medium.com/xgeeks/sentry-and-kubernetes-eabc507c96b7
	* https://raslasarslas.medium.com/how-to-deploy-sentry-on-a-kubernetes-cluster-using-helm-600db31d4486
	* https://github.com/sentry-kubernetes/charts
	* https://github.com/fullfacing/sentry-kubernetes

## other
- add docker buildx remote builders
- look into collectd using the following
	* https://medium.com/@dreampuf/customized-metrics-in-collectd-with-ansible-eddaa39c1972
	* https://middlewaretechnologies.in/2023/12/how-to-install-and-configure-collectd-with-network-plugin-using-ansible.html
	* https://github.com/AerisCloud/ansible-collectd
	* https://github.com/azavea/ansible-collectd
	* https://github.com/bertvv/ansible-role-collectd
	* https://github.com/robertdebock/ansible-role-collectd
	* https://github.com/Stouts/Stouts.collectd
	* https://github.com/opennext-io/ansible-collectd
	* https://github.com/buluma/ansible-role-collectd
	* https://github.com/Oefenweb/ansible-collectd
	* https://github.com/nlware/ansible-collectd
	* https://github.com/giovtorres/ansible-role-collectd
	* https://github.com/Temelio/ansible-role-collectd
	* https://github.com/wasanthag/ansible_deploy_collectd_prometheus
