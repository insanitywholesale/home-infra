#!/bin/sh

ansible-playbook -i inventory/k3s-inventory.ini playbooks/k3s-reset.yml
ansible-playbook -i inventory/k3s-inventory.ini playbooks/k3s-ha-reset.yml
ansible-playbook -i inventory/k3s-inventory.ini playbooks/k3s-ha-reset.yml
ansible-playbook -i inventory/k3s-inventory.ini playbooks/kates.yml
terraform destroy --auto-approve
