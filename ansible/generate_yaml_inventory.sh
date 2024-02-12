#!/bin/sh

cat inventory/*.ini > inventory/inventory.ini
ansible-inventory -i inventory/inventory.ini -y --list > inventory/inventory.yml
ansible-lint --fix inventory/inventory.yml &> /dev/null
rm inventory/inventory.ini
