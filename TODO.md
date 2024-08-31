# todos
things to do

## ansible
- configure grafana to connect to influxdb and prometheus
- add gitlab-runner playbook based on [this role](https://github.com/riemers/ansible-gitlab-runner) and potentially [this module](https://docs.ansible.com/ansible/latest/collections/community/general/gitlab_runner_module.html)
- extend gitlab playbook according to [next steps](https://docs.gitlab.com/ee/install/next_steps.html)
- add github actions runner playbook based on [this role](https://github.com/MonolithProjects/ansible-github_actions_runner)
- add keycloak playbook based on [this post](https://developers.redhat.com/articles/2023/02/20/automate-your-sso-ansible-and-keycloak) and [this post](https://developers.redhat.com/articles/2022/04/20/deploy-keycloak-single-sign-ansible) and using [this collection](https://github.com/ansible-middleware/keycloak)
- add SSL certs to netbox (add `https = =0,netbox.home.inherently.xyz.crt,netbox.home.inherently.xyz.key,HIGH` to `netbox_uwsgi_options: {}` and also move the certs inside there with that name
- add SSL certs to deluge (move cert and key inside `{{ deluge_config_dir }}/ssl` and name them `daemon.cert` and `daemon.pkey`)
- extend step-ca playbook to generate certs based on [this collection](https://github.com/maxhoesel-ansible/ansible-collection-smallstep)
- add postgres backup using [pgbackrest](https://bun.uptrace.dev/postgres/pgbackrest-s3-backups.html)
- continue work on powerdns playbook using [this role](https://github.com/PowerDNS/pdns-ansible) and [this role](https://github.com/PowerDNS/pdns_recursor-ansible)
- add netbootxyz playbook based on [this role](https://github.com/netbootxyz/netboot.xyz/tree/2.0.77/roles/netbootxyz) that is already included and using vars files [endpoints.yml](https://github.com/netbootxyz/netboot.xyz/blob/2.0.77/endpoints.yml) and [user\_overrides.yml](https://github.com/netbootxyz/netboot.xyz/blob/2.0.77/user_overrides.yml)
- add graylog playbook based on [this role](https://github.com/Graylog2/graylog-ansible-role)
- add nexus playbook based on [this role](https://github.com/ansible-ThoTeam/nexus3-oss)

## terraform
- structure terraform better with help from [this article](https://12ft.io/proxy?q=https%3A%2F%2Fmedium.com%2Fcodex%2Fterraform-best-practices-limit-resources-in-your-project-a3f3275f7bbf)
- move to [this terraform provider](https://github.com/bpg/terraform-provider-proxmox)
- create windows template with help from [this blog post](https://yetiops.net/posts/proxmox-terraform-cloudinit-windows/) and [this blog post](https://blog.sunshower.io/2021/02/22/building-a-home-cloud-with-proxmox-dns-terraform/)

## proxmox
- use ansible to add letsencrypt certificates for proxmox individual hosts (hopefully using [this feature branch from lae.proxmox](https://github.com/lae/ansible-role-proxmox/pull/147))
- make non-k3s VMs HA
- enable ceph
- enable ceph S3 using the following sources
	* https://web.archive.org/web/20190721212730/https://dragontek.com/blog/post/adding-s3-capabilities-proxmox
	* https://base64.co.za/enable-amazon-s3-interface-for-ceph-inside-proxmox/
	* https://forum.proxmox.com/threads/trying-to-setup-ceph-radosgw-for-s3-entry.131788/
- configure haproxy on router to have a single endpoint for proxmox cluster according to the following
	* https://pve.proxmox.com/wiki/Web\_Interface\_Via\_Nginx\_Proxy
	* https://www.armand.nz/notes/ProxMox/Installing%20Nginx%20as%20a%20reverse%20proxy%20for%20your%20Proxmox%20Web%20interface
	* https://forum.proxmox.com/threads/using-nginx-as-reverse-proxy-externally.116127/

## k3s
- add longhorn by making 100gb disks on the 2tb drives per k3s vm or some alternative
- add renovatebot to repo to update images
- add [system-upgrade-controller](https://github.com/rancher/system-upgrade-controller)
- look into [Cluster API Provider for Proxmox](https://github.com/ionos-cloud/cluster-api-provider-proxmox)
- add sentry-kubernetes to send errors to sentry using the following (if glitchtip supports it):
	* https://blog.sentry.io/surface-kubernetes-errors-with-sentry/
	* https://github.com/getsentry/sentry-kubernetes
	* https://medium.com/xgeeks/sentry-and-kubernetes-eabc507c96b7
	* https://raslasarslas.medium.com/how-to-deploy-sentry-on-a-kubernetes-cluster-using-helm-600db31d4486
	* https://github.com/sentry-kubernetes/charts
	* https://github.com/fullfacing/sentry-kubernetes

## other
- nothing _for now_
