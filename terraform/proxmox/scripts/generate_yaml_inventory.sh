#!/bin/sh

cat inventory/*.ini > inventory/inventory.ini
ansible-inventory -y --list > inventory/inventory.yaml
rm inventory/inventory.ini
