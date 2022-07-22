#/bin/bash

if [ -z "$1" ]
then
	VMID=9011
else
	VMID="$1"
fi

if [ -z "$2" ]
then
	VMNAME="debian-11-template"
else
	VMNAME="$2"
fi

VMEXISTS="$(qm list | grep $VMID)"

if [ "$VMEXISTS" ]
then
	echo "VM with ${VMID} already exists; exiting gracefully"
	exit 0
else
	qm create "${VMID}" -name "${VMNAME}" -memory 1024 -net0 virtio,bridge=vmbr0 -cores 1 -sockets 1 -cpu cputype=kvm64 -description "debian 11 template" -kvm 1 -numa 1
	qm importdisk "${VMID}" debian-11-amd64.qcow2 local-zfs
	qm set "${VMID}" -scsihw virtio-scsi-pci -virtio0 local-zfs:vm-"${VMID}"-disk-0
	qm set "${VMID}" -serial0 socket
	qm set "${VMID}" -boot c -bootdisk virtio0
	qm set "${VMID}" -agent 1
	qm set "${VMID}" -hotplug disk,network,usb,memory,cpu
	qm set "${VMID}" -vcpus 1
	qm set "${VMID}" -vga qxl
	qm set "${VMID}" -name "${VMNAME}"
	qm set "${VMID}" -ide2 local-zfs:cloudinit
	qm template "${VMID}"
fi
