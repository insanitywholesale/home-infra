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


# License-related stuff

 plz don't sue me

- only the stuff I write are subject to the license of this repo. the projects included are under their own licenses
- original k3s-ansible stuff are under under [their own license](https://github.com/k3s-io/k3s-ansible/blob/master/LICENSE)
- HA k3s-ansible stuff are under under [their own license](https://github.com/techno-tim/k3s-ansible/blob/master/LICENSE)
