#!/bin/sh

terraform plan -out tf-plans/create-k3s-vms.plan
terraform apply -parallelism=3 tf-plans/create-k3s-vms.plan
ansible-playbook -i inventory/k3s-inventory.ini playbooks/kates.yml
ansible-playbook -i inventory/k3s-inventory.ini playbooks/k3s-site.yml
ansible-playbook -i inventory/k3s-inventory.ini playbooks/k3s-ha-site.yml
