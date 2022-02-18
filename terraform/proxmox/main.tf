terraform {
	required_providers {
		proxmox = {
			source = "Telmate/proxmox"
			version = ">=2.9.5"
		}
	}
}

provider "proxmox" {
	alias = "pve0"
    pm_tls_insecure = true
    pm_api_url = "https://192.168.70.1:8006/api2/json"
    pm_password = "failfail"
    pm_user = "root@pam"
}

provider "proxmox" {
	alias = "pve1"
	pm_tls_insecure = true
	pm_api_url = "https://192.168.70.2:8006/api2/json"
	pm_password = "failfail"
	pm_user = "root@pam"
}

resource "proxmox_vm_qemu" "proxmox_vm_k3s" {
	provider = proxmox.pve0
	count = 2
	name = "deb-k3s-${count.index + 1}"
	target_node = "pve0"

	/* change to debian-templ for 11 */
	clone = "debian-tmpl"
	os_type = "cloud-init"
	cores = 2
	sockets = "1"
	cpu = "host"
	memory = 2560
	scsihw = "virtio-scsi-pci"
	bootdisk = "virtio0"
	agent = 0
	onboot = true

	disk {
		size = "30G"
		type = "virtio"
		storage = "local-zfs"
	}

	network {
		model = "virtio"
		bridge = "vmbr0"
	}

	ipconfig0 = "ip=192.168.14.5${count.index + 1}/16,gw=192.168.0.1"

	sshkeys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC5jzKi37jm3517bqThbw+7LR/GXm3qC6Az5F+ZUa36vYM7Ygk2K5bWcFIL2YUCrkL5jfSsvoowONjCAxyuoyxtW4MJxnQLyq4u4yDsRC7YvBPAKZUYaHwnbkCfDs5a75dEFOoDxCA0DY2GrhqzBndaTcCfl0fZ4vN+9LcKOb1dSKiHeHvsh35YNtwntbL21meo+hiycUEgGwNe9/4kxKpdGTr7HvbeX2Fjm/UZBZIJKVcGop/3gCHXYnKH+OY5zc8cmt9Jg4CIwEqrSKeOX0bE8LSPRpVRXH4v8OcMaMei/HQejlH8NBwybEdJ4mhl8vHaFEjDbIWoOujmiRQF2263 angle@puddle"

	lifecycle {
		ignore_changes = [
			cipassword,
			network,
			desc,
		]
	}
}

resource "proxmox_vm_qemu" "reverse-proxy-ngx" {
	provider = proxmox.pve0
	count = 0
	name = "deb-nginx-${count.index + 1}"
	target_node = "pve0"

	/* change to debian-templ for 11 */
	clone = "debian-tmpl"
	os_type = "cloud-init"
	cores = 2
	sockets = "1"
	cpu = "host"
	memory = 1536
	scsihw = "virtio-scsi-pci"
	bootdisk = "virtio0"
	agent = 0
	onboot = true

	disk {
		size = "20G"
		type = "virtio"
		storage = "local-zfs"
	}

	network {
		model = "virtio"
		bridge = "vmbr0"
	}

	ipconfig0 = "ip=192.168.9.10/16,gw=192.168.0.1"

	sshkeys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC5jzKi37jm3517bqThbw+7LR/GXm3qC6Az5F+ZUa36vYM7Ygk2K5bWcFIL2YUCrkL5jfSsvoowONjCAxyuoyxtW4MJxnQLyq4u4yDsRC7YvBPAKZUYaHwnbkCfDs5a75dEFOoDxCA0DY2GrhqzBndaTcCfl0fZ4vN+9LcKOb1dSKiHeHvsh35YNtwntbL21meo+hiycUEgGwNe9/4kxKpdGTr7HvbeX2Fjm/UZBZIJKVcGop/3gCHXYnKH+OY5zc8cmt9Jg4CIwEqrSKeOX0bE8LSPRpVRXH4v8OcMaMei/HQejlH8NBwybEdJ4mhl8vHaFEjDbIWoOujmiRQF2263 angle@puddle"

	lifecycle {
		ignore_changes = [
			cipassword,
			network,
			desc,
		]
	}
}

resource "proxmox_vm_qemu" "reverse-proxy-hap" {
	provider = proxmox.pve0
	count = 0
	name = "deb-haproxy-${count.index + 1}"
	target_node = "pve0"

	/* change to debian-templ for 11 */
	clone = "debian-tmpl"
	os_type = "cloud-init"
	cores = 2
	sockets = "1"
	cpu = "host"
	memory = 1536
	scsihw = "virtio-scsi-pci"
	bootdisk = "virtio0"
	agent = 0
	onboot = true

	disk {
		size = "20G"
		type = "virtio"
		storage = "local-zfs"
	}

	network {
		model = "virtio"
		bridge = "vmbr0"
	}

	ipconfig0 = "ip=192.168.9.11/16,gw=192.168.0.1"

	sshkeys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC5jzKi37jm3517bqThbw+7LR/GXm3qC6Az5F+ZUa36vYM7Ygk2K5bWcFIL2YUCrkL5jfSsvoowONjCAxyuoyxtW4MJxnQLyq4u4yDsRC7YvBPAKZUYaHwnbkCfDs5a75dEFOoDxCA0DY2GrhqzBndaTcCfl0fZ4vN+9LcKOb1dSKiHeHvsh35YNtwntbL21meo+hiycUEgGwNe9/4kxKpdGTr7HvbeX2Fjm/UZBZIJKVcGop/3gCHXYnKH+OY5zc8cmt9Jg4CIwEqrSKeOX0bE8LSPRpVRXH4v8OcMaMei/HQejlH8NBwybEdJ4mhl8vHaFEjDbIWoOujmiRQF2263 angle@puddle"

	lifecycle {
		ignore_changes = [
			cipassword,
			network,
			desc,
		]
	}
}

resource "proxmox_vm_qemu" "proxmox_vm_k3s2" {
	provider = proxmox.pve1
	count = 2
	name = "deb-k3s2-${count.index + 1}"
	target_node = "pve1"

	/* change to debian-templ for 11 */
	clone = "debian-tmpl"
	os_type = "cloud-init"
	cores = 2
	sockets = "1"
	cpu = "host"
	memory = 3084
	scsihw = "virtio-scsi-pci"
	bootdisk = "virtio0"
	agent = 0
	onboot = true

	disk {
		size = "30G"
		type = "virtio"
		storage = "local-zfs"
	}

	network {
		model = "virtio"
		bridge = "vmbr0"
	}

	ipconfig0 = "ip=192.168.15.5${count.index + 1}/16,gw=192.168.0.1"

	sshkeys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC5jzKi37jm3517bqThbw+7LR/GXm3qC6Az5F+ZUa36vYM7Ygk2K5bWcFIL2YUCrkL5jfSsvoowONjCAxyuoyxtW4MJxnQLyq4u4yDsRC7YvBPAKZUYaHwnbkCfDs5a75dEFOoDxCA0DY2GrhqzBndaTcCfl0fZ4vN+9LcKOb1dSKiHeHvsh35YNtwntbL21meo+hiycUEgGwNe9/4kxKpdGTr7HvbeX2Fjm/UZBZIJKVcGop/3gCHXYnKH+OY5zc8cmt9Jg4CIwEqrSKeOX0bE8LSPRpVRXH4v8OcMaMei/HQejlH8NBwybEdJ4mhl8vHaFEjDbIWoOujmiRQF2263 angle@puddle"

	lifecycle {
		ignore_changes = [
			cipassword,
			network,
			desc,
		]
	}
}

resource "local_file" "hosts_cfg_k3s" {
	content = templatefile(
		"${path.module}/inventory.tftpl",
		{
			k3s_hosts = proxmox_vm_qemu.proxmox_vm_k3s.*,
			k3s2_hosts = proxmox_vm_qemu.proxmox_vm_k3s2.*,
		}
	)
	filename = "inventory"
	file_permission = "0644"
}
