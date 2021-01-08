provider "proxmox" {
    pm_tls_insecure = true
    pm_api_url = "https://pve-0.hell:8006/api2/json"
    pm_password = "failfail"
    pm_user = "root@pam"
}

resource "proxmox_vm_qemu" "proxmox_vm_k3s" {

	count = 3
	name = "deb-k3s-${count.index + 1}"
	target_node = "pve-0"

	clone = "debian-templ"
	os_type = "cloud-init"
	cores = 2
	sockets = "1"
	cpu = "host"
	memory = 2560
	scsihw = "virtio-scsi-pci"
	bootdisk = "virtio0"
	agent = 1

	disk {
		id = 0
		size = 50
		type = "virtio"
		storage = "local-zfs"
		storage_type = "zfspool"
		iothread = true
		backup = false
	}

	network {
		id = 0
		model = "virtio"
		bridge = "vmbr0"
	}

	lifecycle {
		ignore_changes = [
			cipassword,
			network,
			desc,
		]
	}

	ipconfig0 = "ip=192.168.4.4${count.index + 1}/16,gw=192.168.0.1"

	sshkeys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC5jzKi37jm3517bqThbw+7LR/GXm3qC6Az5F+ZUa36vYM7Ygk2K5bWcFIL2YUCrkL5jfSsvoowONjCAxyuoyxtW4MJxnQLyq4u4yDsRC7YvBPAKZUYaHwnbkCfDs5a75dEFOoDxCA0DY2GrhqzBndaTcCfl0fZ4vN+9LcKOb1dSKiHeHvsh35YNtwntbL21meo+hiycUEgGwNe9/4kxKpdGTr7HvbeX2Fjm/UZBZIJKVcGop/3gCHXYnKH+OY5zc8cmt9Jg4CIwEqrSKeOX0bE8LSPRpVRXH4v8OcMaMei/HQejlH8NBwybEdJ4mhl8vHaFEjDbIWoOujmiRQF2263 angle@puddle"

}

resource "proxmox_vm_qemu" "proxmox_vm_swarm" {

	count = 3
	name = "deb-swarm-${count.index + 1}"
	target_node = "pve-0"

	clone = "debian-templ"
	os_type = "cloud-init"
	cores = 1
	sockets = "1"
	cpu = "host"
	memory = 1024
	scsihw = "virtio-scsi-pci"
	bootdisk = "virtio0"
	agent = 1

	disk {
		id = 0
		size = 40
		type = "virtio"
		storage = "local-zfs"
		storage_type = "zfspool"
		iothread = true
		backup = false
	}

	network {
		id = 0
		model = "virtio"
		bridge = "vmbr0"
	}

	lifecycle {
		ignore_changes = [
			cipassword,
			network,
			desc,
		]
	}

	ipconfig0 = "ip=192.168.5.5${count.index + 1}/16,gw=192.168.0.1"

	sshkeys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC5jzKi37jm3517bqThbw+7LR/GXm3qC6Az5F+ZUa36vYM7Ygk2K5bWcFIL2YUCrkL5jfSsvoowONjCAxyuoyxtW4MJxnQLyq4u4yDsRC7YvBPAKZUYaHwnbkCfDs5a75dEFOoDxCA0DY2GrhqzBndaTcCfl0fZ4vN+9LcKOb1dSKiHeHvsh35YNtwntbL21meo+hiycUEgGwNe9/4kxKpdGTr7HvbeX2Fjm/UZBZIJKVcGop/3gCHXYnKH+OY5zc8cmt9Jg4CIwEqrSKeOX0bE8LSPRpVRXH4v8OcMaMei/HQejlH8NBwybEdJ4mhl8vHaFEjDbIWoOujmiRQF2263 angle@puddle"

}

/*
resource "proxmox_vm_qemu" "proxmox_vm_keycloak" {

	count = 1
	name = "keycloak-${count.index + 1}"
	target_node = "pve-0"

	clone = "debian-templ"
	os_type = "cloud-init"
	cores = 2
	sockets = "1"
	cpu = "host"
	memory = 2048
	scsihw = "virtio-scsi-pci"
	bootdisk = "virtio0"
	agent = 1

	disk {
		id = 0
		size = 30
		type = "virtio"
		storage = "local-zfs"
		storage_type = "zfspool"
		iothread = true
		backup = false
	}

	network {
		id = 0
		model = "virtio"
		bridge = "vmbr0"
	}

	lifecycle {
		ignore_changes = [
			network,
			desc,
		]
	}

	ipconfig0 = "ip=192.168.3.11/16,gw=192.168.0.1"

	sshkeys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC5jzKi37jm3517bqThbw+7LR/GXm3qC6Az5F+ZUa36vYM7Ygk2K5bWcFIL2YUCrkL5jfSsvoowONjCAxyuoyxtW4MJxnQLyq4u4yDsRC7YvBPAKZUYaHwnbkCfDs5a75dEFOoDxCA0DY2GrhqzBndaTcCfl0fZ4vN+9LcKOb1dSKiHeHvsh35YNtwntbL21meo+hiycUEgGwNe9/4kxKpdGTr7HvbeX2Fjm/UZBZIJKVcGop/3gCHXYnKH+OY5zc8cmt9Jg4CIwEqrSKeOX0bE8LSPRpVRXH4v8OcMaMei/HQejlH8NBwybEdJ4mhl8vHaFEjDbIWoOujmiRQF2263 angle@puddle"

}

resource "proxmox_vm_qemu" "proxmox_vm_sentry" {

	count = 1
	name = "sentry-${count.index + 1}"
	target_node = "pve-0"

	clone = "debian-templ"
	os_type = "cloud-init"
	cores = 2
	sockets = "1"
	cpu = "host"
	memory = 2560
	scsihw = "virtio-scsi-pci"
	bootdisk = "virtio0"
	agent = 1

	disk {
		id = 0
		size = 30
		type = "virtio"
		storage = "local-zfs"
		storage_type = "zfspool"
		iothread = true
		backup = false
	}

	network {
		id = 0
		model = "virtio"
		bridge = "vmbr0"
	}

	lifecycle {
		ignore_changes = [
			network,
			desc,
		]
	}

	ipconfig0 = "ip=192.168.3.17/16,gw=192.168.0.1"

	sshkeys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC5jzKi37jm3517bqThbw+7LR/GXm3qC6Az5F+ZUa36vYM7Ygk2K5bWcFIL2YUCrkL5jfSsvoowONjCAxyuoyxtW4MJxnQLyq4u4yDsRC7YvBPAKZUYaHwnbkCfDs5a75dEFOoDxCA0DY2GrhqzBndaTcCfl0fZ4vN+9LcKOb1dSKiHeHvsh35YNtwntbL21meo+hiycUEgGwNe9/4kxKpdGTr7HvbeX2Fjm/UZBZIJKVcGop/3gCHXYnKH+OY5zc8cmt9Jg4CIwEqrSKeOX0bE8LSPRpVRXH4v8OcMaMei/HQejlH8NBwybEdJ4mhl8vHaFEjDbIWoOujmiRQF2263 angle@puddle"

}



resource "proxmox_lxc" "ubuntu_mysql_lxc" {

	count = 1

    features {
        nesting = true
    }

	start = true

	memory = 768

    hostname = "ubuntu-mysql-${count.index}"

    network {
        name = "eth0"
        bridge = "vmbr0"
        ip = "192.168.5.36/16,gw=192.168.0.1"
    }

	ssh_public_keys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC5jzKi37jm3517bqThbw+7LR/GXm3qC6Az5F+ZUa36vYM7Ygk2K5bWcFIL2YUCrkL5jfSsvoowONjCAxyuoyxtW4MJxnQLyq4u4yDsRC7YvBPAKZUYaHwnbkCfDs5a75dEFOoDxCA0DY2GrhqzBndaTcCfl0fZ4vN+9LcKOb1dSKiHeHvsh35YNtwntbL21meo+hiycUEgGwNe9/4kxKpdGTr7HvbeX2Fjm/UZBZIJKVcGop/3gCHXYnKH+OY5zc8cmt9Jg4CIwEqrSKeOX0bE8LSPRpVRXH4v8OcMaMei/HQejlH8NBwybEdJ4mhl8vHaFEjDbIWoOujmiRQF2263 angle@puddle"

    ostemplate = "local:vztmpl/ubuntu-18.04-standard_18.04.1-1_amd64.tar.gz"
    password = "failfail"
    storage = "local-zfs"
    target_node = "pve-0"
    unprivileged = true
}

resource "proxmox_lxc" "ubuntu_nginx_lxc" {

	count = 1

    features {
        nesting = true
    }

	start = true

    hostname = "ubuntu-nginx-${count.index}"

    network {
        name = "eth0"
        bridge = "vmbr0"
        ip = "192.168.5.80/16,gw=192.168.0.1"
    }

	ssh_public_keys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC5jzKi37jm3517bqThbw+7LR/GXm3qC6Az5F+ZUa36vYM7Ygk2K5bWcFIL2YUCrkL5jfSsvoowONjCAxyuoyxtW4MJxnQLyq4u4yDsRC7YvBPAKZUYaHwnbkCfDs5a75dEFOoDxCA0DY2GrhqzBndaTcCfl0fZ4vN+9LcKOb1dSKiHeHvsh35YNtwntbL21meo+hiycUEgGwNe9/4kxKpdGTr7HvbeX2Fjm/UZBZIJKVcGop/3gCHXYnKH+OY5zc8cmt9Jg4CIwEqrSKeOX0bE8LSPRpVRXH4v8OcMaMei/HQejlH8NBwybEdJ4mhl8vHaFEjDbIWoOujmiRQF2263 angle@puddle"

    ostemplate = "local:vztmpl/ubuntu-18.04-standard_18.04.1-1_amd64.tar.gz"
    password = "failfail"
    storage = "local-zfs"
    target_node = "pve-0"
    unprivileged = true

}
*/

output "rancher_ips" {
	value = proxmox_vm_qemu.proxmox_vm_k3s.*.ipconfig0
}
output "swarm_ips" {
	value = proxmox_vm_qemu.proxmox_vm_swarm.*.ipconfig0
}
