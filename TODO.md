- use terraform local executor to run ansible playbook after vm provisioning
- figure out if there is a debian image with qemu-guest-agent preinstalled
- fix template vm scripts to not run if templates exist
- make `kates.yml` reboot only the first time AKA only when required
- move from [democratic-csi](https://github.com/democratic-csi/democratic-csi) to [nfs-subdir-external-provisioner](https://github.com/kubernetes-sigs/nfs-subdir-external-provisioner)
- customize images before templating
	* [with terraform remote-exec](https://cloudalbania.com/posts/2022-01-homelab-with-proxmox-and-terraform/#considerations-when-creating-vms)
	* or [with packer](https://www.youtube.com/watch?v=1nf3WOEFq1Y)
	* or [with guestfs-tools](https://austinsnerdythings.com/2021/08/30/how-to-create-a-proxmox-ubuntu-cloud-init-image/)
