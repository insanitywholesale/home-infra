# infra

infrastructure-related things I'm testing/working on including automating my homelab

## things in here
there are a few top-level directories here.
- the active ones:
	* `kube` includes kubernetes yaml manifests as well as Helm values.yaml configs
	* `terraform/proxmox` includes terraform configuration as well as ansible playbooks for k3s
- the archive ones:
	* `vagrant` has some basic examples for how to write a Vagrantfile
	* `raw-libvirt` is the older version of the terraform+proxmox setup but with libvirt instead of proxmox for virtualization


# License-related stuff

 plz don't sue me

- only the stuff I write are subject to the license of this repo. the projects included are under their own licenses
- k3s-ansible stuff are under under [their own license](https://github.com/k3s-io/k3s-ansible/blob/master/LICENSE) and the specific files are:
	* `terraform/proxmox/group_vars/`
	* `terraform/proxmox/k3s2_roles/`
	* `terraform/proxmox/k3s_roles/`
	* `terraform/proxmox/reset.yml`
	* `terraform/proxmox/site.yml`
