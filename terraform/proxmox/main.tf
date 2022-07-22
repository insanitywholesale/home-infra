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
	pm_timeout = 900
}

provider "proxmox" {
	alias = "pve1"
	pm_tls_insecure = true
	pm_api_url = "https://192.168.70.2:8006/api2/json"
	pm_password = "failfail"
	pm_user = "root@pam"
	pm_timeout = 900
}

resource "proxmox_vm_qemu" "proxmox_vm_k3s" {
	provider = proxmox.pve0
	count = 4
	name = "deb-k3s-${count.index + 1}"
	desc = "non-HA k3s cluster host ${count.index + 1}"
	target_node = "pve0"

	/* change to debian-templ for 11 */
	clone = "debian-templ"
	os_type = "cloud-init"
	cores = 2
	sockets = 1
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
		tag = 50
	}

	ipconfig0 = "ip=10.0.50.4${count.index + 1}/16,gw=10.0.50.254"

	sshkeys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC5jzKi37jm3517bqThbw+7LR/GXm3qC6Az5F+ZUa36vYM7Ygk2K5bWcFIL2YUCrkL5jfSsvoowONjCAxyuoyxtW4MJxnQLyq4u4yDsRC7YvBPAKZUYaHwnbkCfDs5a75dEFOoDxCA0DY2GrhqzBndaTcCfl0fZ4vN+9LcKOb1dSKiHeHvsh35YNtwntbL21meo+hiycUEgGwNe9/4kxKpdGTr7HvbeX2Fjm/UZBZIJKVcGop/3gCHXYnKH+OY5zc8cmt9Jg4CIwEqrSKeOX0bE8LSPRpVRXH4v8OcMaMei/HQejlH8NBwybEdJ4mhl8vHaFEjDbIWoOujmiRQF2263 angle@puddle"

	lifecycle {
		ignore_changes = [
			cipassword,
			network,
			desc,
		]
	}
}

resource "proxmox_vm_qemu" "proxmox_vm_k3s_ha_masters" {
	provider = proxmox.pve1
	count = 3
	name = "deb-k3s-m-${count.index + 1}"
	desc = "HA k3s cluster master host ${count.index + 1}"
	target_node = "pve1"

	/* change to debian-templ for 11 */
	clone = "debian-tmpl"
	os_type = "cloud-init"
	cores = 2
	sockets = 1
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
		bridge = "vmbr1"
		tag = 50
	}

	ipconfig0 = "ip=10.0.50.5${count.index + 1}/16,gw=10.0.50.254"

	sshkeys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC5jzKi37jm3517bqThbw+7LR/GXm3qC6Az5F+ZUa36vYM7Ygk2K5bWcFIL2YUCrkL5jfSsvoowONjCAxyuoyxtW4MJxnQLyq4u4yDsRC7YvBPAKZUYaHwnbkCfDs5a75dEFOoDxCA0DY2GrhqzBndaTcCfl0fZ4vN+9LcKOb1dSKiHeHvsh35YNtwntbL21meo+hiycUEgGwNe9/4kxKpdGTr7HvbeX2Fjm/UZBZIJKVcGop/3gCHXYnKH+OY5zc8cmt9Jg4CIwEqrSKeOX0bE8LSPRpVRXH4v8OcMaMei/HQejlH8NBwybEdJ4mhl8vHaFEjDbIWoOujmiRQF2263 angle@puddle"

	lifecycle {
		ignore_changes = [
			cipassword,
			network,
			desc,
		]
	}
}

resource "proxmox_vm_qemu" "proxmox_vm_k3s_ha_workers" {
	provider = proxmox.pve1
	count = 3
	name = "deb-k3s-w-${count.index + 1}"
	desc = "HA k3s cluster worker host ${count.index + 1}"
	target_node = "pve1"

	/* change to debian-templ for 11 */
	clone = "debian-tmpl"
	os_type = "cloud-init"
	cores = 2
	sockets = 1
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
		bridge = "vmbr1"
		tag = 50
	}

	ipconfig0 = "ip=10.0.50.6${count.index + 1}/16,gw=10.0.50.254"

	sshkeys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC5jzKi37jm3517bqThbw+7LR/GXm3qC6Az5F+ZUa36vYM7Ygk2K5bWcFIL2YUCrkL5jfSsvoowONjCAxyuoyxtW4MJxnQLyq4u4yDsRC7YvBPAKZUYaHwnbkCfDs5a75dEFOoDxCA0DY2GrhqzBndaTcCfl0fZ4vN+9LcKOb1dSKiHeHvsh35YNtwntbL21meo+hiycUEgGwNe9/4kxKpdGTr7HvbeX2Fjm/UZBZIJKVcGop/3gCHXYnKH+OY5zc8cmt9Jg4CIwEqrSKeOX0bE8LSPRpVRXH4v8OcMaMei/HQejlH8NBwybEdJ4mhl8vHaFEjDbIWoOujmiRQF2263 angle@puddle"

	lifecycle {
		ignore_changes = [
			cipassword,
			network,
			desc,
		]
	}
}

resource "proxmox_vm_qemu" "proxmox_vm_arch" {
	provider = proxmox.pve1
	count = 0
	name = "arch-${count.index + 1}"
	target_node = "pve1"

	/* change to debian-templ for 11 */
	clone = "arch-tmpl"
	os_type = "cloud-init"
	cores = 2
	sockets = 1
	cpu = "host"
	memory = 1024
	scsihw = "virtio-scsi-pci"
	bootdisk = "virtio0"
	agent = 1
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

	ipconfig0 = "ip=192.168.3.${count.index}/16,gw=192.168.0.1"

	sshkeys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC5jzKi37jm3517bqThbw+7LR/GXm3qC6Az5F+ZUa36vYM7Ygk2K5bWcFIL2YUCrkL5jfSsvoowONjCAxyuoyxtW4MJxnQLyq4u4yDsRC7YvBPAKZUYaHwnbkCfDs5a75dEFOoDxCA0DY2GrhqzBndaTcCfl0fZ4vN+9LcKOb1dSKiHeHvsh35YNtwntbL21meo+hiycUEgGwNe9/4kxKpdGTr7HvbeX2Fjm/UZBZIJKVcGop/3gCHXYnKH+OY5zc8cmt9Jg4CIwEqrSKeOX0bE8LSPRpVRXH4v8OcMaMei/HQejlH8NBwybEdJ4mhl8vHaFEjDbIWoOujmiRQF2263 angle@puddle"

	lifecycle {
		ignore_changes = [
			cipassword,
			network,
			desc,
		]
	}
}

/* this is also interesting https://github.com/NatiSayada/k3s-proxmox-terraform-ansible/blob/main/terraform/main.tf */
resource "local_file" "hosts_cfg_k3s" {
	content = templatefile(
		"${path.module}/inventory/k3s-inventory.ini.tftpl",
		{
			k3s_hosts = proxmox_vm_qemu.proxmox_vm_k3s.*,
			k3s_masters = proxmox_vm_qemu.proxmox_vm_k3s_ha_masters.*,
			k3s_workers = proxmox_vm_qemu.proxmox_vm_k3s_ha_workers.*,
		}
	)
	filename = "inventory/k3s-inventory.ini"
	file_permission = "0644"
}
