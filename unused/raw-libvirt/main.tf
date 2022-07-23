provider "libvirt" {
	uri   = "qemu+ssh://root@stronghold.hell/system"
}

resource "libvirt_volume" "debk3s-qcow2" {
	name = "debian.qcow2"
	pool =  "default"
	source = "./debian-10-openstack-amd64.qcow2"
	format = "qcow2"
}

resource "libvirt_domain" "debk3s" {
	count = 1

	name   = "debk3s-${count.index}"
	memory = "2048"
	vcpu   = 2
	
	network_interface {
		network_name = "default"
	}
	
	disk {
		volume_id = libvirt_volume.debk3s-qcow2.id
	}
	
	console {
		type = "pty"
		target_type = "serial"
		target_port = "0"
	}
	
	graphics {
		type = "spice"
		listen_type = "address"
		autoport = true
	}
}
