#!/bin/sh

cat inventory/*.ini > inventory/inventory.ini
ansible-inventory -i inventory/inventory.ini -y --list > inventory/inventory.yaml
ansible-lint --fix inventory/inventory.yaml
rm inventory/inventory.ini
