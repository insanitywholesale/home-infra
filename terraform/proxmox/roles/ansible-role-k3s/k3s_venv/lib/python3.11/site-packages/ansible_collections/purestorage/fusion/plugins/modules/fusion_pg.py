#!/usr/bin/python
# -*- coding: utf-8 -*-

# (c) 2022, Simon Dodsley (simon@purestorage.com)
# GNU General Public License v3.0+ (see COPYING.GPLv3 or https://www.gnu.org/licenses/gpl-3.0.txt)

from __future__ import absolute_import, division, print_function

__metaclass__ = type

DOCUMENTATION = r"""
---
module: fusion_pg
version_added: '1.0.0'
short_description:  Manage placement groups in Pure Storage Fusion
description:
- Create, update or delete a placement groups in Pure Storage Fusion.
author:
- Pure Storage Ansible Team (@sdodsley) <pure-ansible-team@purestorage.com>
notes:
- Supports C(check mode).
options:
  name:
    description:
    - The name of the placement group.
    type: str
    required: true
  display_name:
    description:
    - The human name of the placement group.
    - If not provided, defaults to I(name).
    type: str
  state:
    description:
    - Define whether the placement group should exist or not.
    type: str
    default: present
    choices: [ absent, present ]
  tenant:
    description:
    - The name of the tenant.
    type: str
    required: true
  tenant_space:
    description:
    - The name of the tenant space.
    type: str
    required: true
  region:
    description:
    - The name of the region the availability zone is in.
    type: str
  availability_zone:
    aliases: [ az ]
    description:
    - The name of the availability zone the placement group is in.
    type: str
  storage_service:
    description:
    - The name of the storage service to create the placement group for.
    type: str
  array:
    description:
    - "Array to place the placement group to. Changing it (i.e. manual migration)
    is an elevated operation."
    type: str
  placement_engine:
    description:
    - For workload placement recommendations from Pure1 Meta, use C(pure1meta).
    - Please note that this might increase volume creation time.
    type: str
    choices: [ heuristics, pure1meta ]
extends_documentation_fragment:
- purestorage.fusion.purestorage.fusion
"""

EXAMPLES = r"""
- name: Create new placement group named foo
  purestorage.fusion.fusion_pg:
    name: foo
    tenant: test
    tenant_space: space_1
    availability_zone: az1
    region: region1
    storage_service: storage_service_1
    state: present
    app_id: key_name
    key_file: "az-admin-private-key.pem"

- name: Delete placement group foo
  purestorage.fusion.fusion_pg:
    name: foo
    tenant: test
    tenant_space: space_1
    state: absent
    app_id: key_name
    key_file: "az-admin-private-key.pem"
"""

RETURN = r"""
"""

try:
    import fusion as purefusion
except ImportError:
    pass

from ansible.module_utils.basic import AnsibleModule
from ansible_collections.purestorage.fusion.plugins.module_utils.fusion import (
    fusion_argument_spec,
)

from ansible_collections.purestorage.fusion.plugins.module_utils.startup import (
    setup_fusion,
)
from ansible_collections.purestorage.fusion.plugins.module_utils.getters import (
    get_tenant,
    get_ts,
)
from ansible_collections.purestorage.fusion.plugins.module_utils.operations import (
    await_operation,
)


def get_pg(module, fusion):
    """Return Placement Group or None"""
    pg_api_instance = purefusion.PlacementGroupsApi(fusion)
    try:
        return pg_api_instance.get_placement_group(
            tenant_name=module.params["tenant"],
            tenant_space_name=module.params["tenant_space"],
            placement_group_name=module.params["name"],
        )
    except purefusion.rest.ApiException:
        return None


def create_pg(module, fusion):
    """Create Placement Group"""

    pg_api_instance = purefusion.PlacementGroupsApi(fusion)

    changed = True
    if not module.check_mode:
        if not module.params["display_name"]:
            display_name = module.params["name"]
        else:
            display_name = module.params["display_name"]
        group = purefusion.PlacementGroupPost(
            availability_zone=module.params["availability_zone"],
            name=module.params["name"],
            display_name=display_name,
            region=module.params["region"],
            storage_service=module.params["storage_service"],
        )
        op = pg_api_instance.create_placement_group(
            group,
            tenant_name=module.params["tenant"],
            tenant_space_name=module.params["tenant_space"],
        )
        await_operation(fusion, op)

    module.exit_json(changed=changed)


def update_display_name(module, fusion, patches, pg):
    if not module.params["display_name"]:
        return
    if module.params["display_name"] == pg.display_name:
        return
    patch = purefusion.PlacementGroupPatch(
        display_name=purefusion.NullableString(module.params["display_name"]),
    )
    patches.append(patch)


def update_array(module, fusion, patches, pg):
    if not module.params["array"]:
        return
    if not pg.array:
        module.warn(
            "cannot see placement group array, probably missing required permissions to change it"
        )
        return
    if pg.array.name == module.params["array"]:
        return

    patch = purefusion.PlacementGroupPatch(
        array=purefusion.NullableString(module.params["array"]),
    )
    patches.append(patch)


def update_pg(module, fusion, pg):
    """Update Placement Group"""

    pg_api_instance = purefusion.PlacementGroupsApi(fusion)
    patches = []

    update_display_name(module, fusion, patches, pg)
    update_array(module, fusion, patches, pg)

    if not module.check_mode:
        for patch in patches:
            op = pg_api_instance.update_placement_group(
                patch,
                tenant_name=module.params["tenant"],
                tenant_space_name=module.params["tenant_space"],
                placement_group_name=module.params["name"],
            )
            await_operation(fusion, op)

    changed = len(patches) != 0

    module.exit_json(changed=changed)


def delete_pg(module, fusion):
    """Delete Placement Group"""
    changed = True
    pg_api_instance = purefusion.PlacementGroupsApi(fusion)
    if not module.check_mode:
        op = pg_api_instance.delete_placement_group(
            placement_group_name=module.params["name"],
            tenant_name=module.params["tenant"],
            tenant_space_name=module.params["tenant_space"],
        )
        await_operation(fusion, op)

    module.exit_json(changed=changed)


def main():
    """Main code"""
    argument_spec = fusion_argument_spec()
    argument_spec.update(
        dict(
            name=dict(type="str", required=True),
            display_name=dict(type="str"),
            tenant=dict(type="str", required=True),
            tenant_space=dict(type="str", required=True),
            region=dict(type="str"),
            availability_zone=dict(type="str", aliases=["az"]),
            storage_service=dict(type="str"),
            state=dict(type="str", default="present", choices=["absent", "present"]),
            array=dict(type="str"),
            placement_engine=dict(
                type="str",
                choices=["heuristics", "pure1meta"],
                removed_in_version="2.0.0",
                removed_from_collection="purestorage.fusion",
            ),
        )
    )

    required_if = [["state", "present", ["storage_service"]]]
    module = AnsibleModule(
        argument_spec, required_if=required_if, supports_check_mode=True
    )
    fusion = setup_fusion(module)

    if module.params["placement_engine"]:
        module.warn("placement_engine parameter will be deprecated in version 2.0.0")

    state = module.params["state"]
    pgroup = get_pg(module, fusion)
    if not (get_tenant(module, fusion) and get_ts(module, fusion)):
        module.fail_json(
            msg="Please check the values for `tenant` and `tenant_space` "
            "to ensure they all exit and have appropriate relationships."
        )
    if state == "present" and not pgroup:
        module.fail_on_missing_params(["region", "availability_zone"])
        create_pg(module, fusion)
    if state == "present" and pgroup:
        update_pg(module, fusion, pgroup)
    elif state == "absent" and pgroup:
        delete_pg(module, fusion)

    module.exit_json(changed=False)


if __name__ == "__main__":
    main()
