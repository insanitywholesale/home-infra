terraform {
	required_providers {
		proxmox = {
			source = "Telmate/proxmox"
			version = "2.7.1"
		}
	}
}

provider "proxmox" {
	pm_tls_insecure = true
	pm_api_url = "https://pve1.hell:8006/api2/json"
	pm_password = "failfail"
	pm_user = "root@pam"
}

resource "proxmox_vm_qemu" "proxmox_vm_k3s" {

	count = 3
	name = "deb-k3s2-${count.index + 1}"
	target_node = "pve1"

	clone = "debian-templ"
	os_type = "cloud-init"
	cores = 2
	sockets = "1"
	cpu = "host"
	memory = 3084
	scsihw = "virtio-scsi-pci"
	bootdisk = "virtio0"
	agent = 1
	guest_agent_ready_timeout = 120
	onboot = false

	disk {
		size = "33G"
		type = "virtio"
		storage = "local-zfs"
		iothread = 1
	}

	network {
		model = "virtio"
		bridge = "vmbr0"
	}

	ipconfig0 = "ip=192.168.5.5${count.index + 4}/16,gw=192.168.0.1"

	sshkeys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC5jzKi37jm3517bqThbw+7LR/GXm3qC6Az5F+ZUa36vYM7Ygk2K5bWcFIL2YUCrkL5jfSsvoowONjCAxyuoyxtW4MJxnQLyq4u4yDsRC7YvBPAKZUYaHwnbkCfDs5a75dEFOoDxCA0DY2GrhqzBndaTcCfl0fZ4vN+9LcKOb1dSKiHeHvsh35YNtwntbL21meo+hiycUEgGwNe9/4kxKpdGTr7HvbeX2Fjm/UZBZIJKVcGop/3gCHXYnKH+OY5zc8cmt9Jg4CIwEqrSKeOX0bE8LSPRpVRXH4v8OcMaMei/HQejlH8NBwybEdJ4mhl8vHaFEjDbIWoOujmiRQF2263 angle@puddle"

}

output "rancher_ips" {
	value = proxmox_vm_qemu.proxmox_vm_k3s.*.ipconfig0
}
