#!/usr/bin/python
# -*- coding: utf-8 -*-

# (c) 2023, Simon Dodsley (simon@purestorage.com), Jan Kodera (jkodera@purestorage.com)
# GNU General Public License v3.0+ (see COPYING.GPLv3 or https://www.gnu.org/licenses/gpl-3.0.txt)

from __future__ import absolute_import, division, print_function

__metaclass__ = type

DOCUMENTATION = r"""
---
module: fusion_volume
version_added: '1.0.0'
short_description:  Manage volumes in Pure Storage Fusion
description:
- Create, update or delete a volume in Pure Storage Fusion.
author:
- Pure Storage Ansible Team (@sdodsley) <pure-ansible-team@purestorage.com>
notes:
- Supports C(check mode).
options:
  name:
    description:
    - The name of the volume.
    type: str
    required: true
  display_name:
    description:
    - The human name of the volume.
    - If not provided, defaults to I(name).
    type: str
  state:
    description:
    - Define whether the volume should exist or not.
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
  eradicate:
    description:
    - "Wipes the volume instead of a soft delete if true. Must be used with `state: absent`."
    type: bool
    default: false
  size:
    description:
    - Volume size in M, G, T or P units.
    type: str
  storage_class:
    description:
    - The name of the storage class.
    type: str
  placement_group:
    description:
    - The name of the placement group.
    type: str
  protection_policy:
    description:
    - The name of the protection policy.
    type: str
  host_access_policies:
    description:
    - 'A list of host access policies to connect the volume to.
        To clear, assign empty list: host_access_policies: []'
    type: list
    elements: str
  rename:
    description:
    - New name for volume.
    type: str
extends_documentation_fragment:
- purestorage.fusion.purestorage.fusion
"""

EXAMPLES = r"""
- name: Create new volume named foo in storage_class fred
  purestorage.fusion.fusion_volume:
    name: foo
    storage_class: fred
    size: 1T
    tenant: test
    tenant_space: space_1
    state: present
    app_id: key_name
    key_file: "az-admin-private-key.pem"

- name: Extend the size of an existing volume named foo
  purestorage.fusion.fusion_volume:
    name: foo
    size: 2T
    tenant: test
    tenant_space: space_1
    state: present
    app_id: key_name
    key_file: "az-admin-private-key.pem"

- name: Rename volume named foo to bar
  purestorage.fusion.fusion_volume:
    name: foo
    rename: bar
    tenant: test
    tenant_space: space_1
    state: absent
    app_id: key_name
    key_file: "az-admin-private-key.pem"

- name: Delete volume named foo
  purestorage.fusion.fusion_volume:
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
from ansible_collections.purestorage.fusion.plugins.module_utils.parsing import (
    parse_number_with_metric_suffix,
    print_number_with_metric_suffix,
)
from ansible_collections.purestorage.fusion.plugins.module_utils.startup import (
    setup_fusion,
)
from ansible_collections.purestorage.fusion.plugins.module_utils.operations import (
    await_operation,
)


def get_volume(module, fusion):
    """Return Volume or None"""
    volume_api_instance = purefusion.VolumesApi(fusion)
    try:
        return volume_api_instance.get_volume(
            tenant_name=module.params["tenant"],
            tenant_space_name=module.params["tenant_space"],
            volume_name=module.params["name"],
        )
    except purefusion.rest.ApiException:
        return None


def get_storage_class(module, fusion):
    """Return Storage Class or None"""
    pg_api_instance = purefusion.PlacementGroupsApi(fusion)
    pg = pg_api_instance.get_placement_group(
        tenant_name=module.params["tenant"],
        tenant_space_name=module.params["tenant_space"],
        placement_group_name=module.params["placement_group"],
    )
    sc_api_instance = purefusion.StorageClassesApi(fusion)
    try:
        return sc_api_instance.get_storage_class(
            storage_service_name=pg.storage_service.name,
            storage_class_name=module.params["storage_class"],
        )
    except purefusion.rest.ApiException:
        return None


def get_protection_group(module, fusion):
    """Return Placement Group or None"""
    pg_api_instance = purefusion.PlacementGroupsApi(fusion)
    try:
        return pg_api_instance.get_placement_group(
            tenant_name=module.params["tenant"],
            tenant_space_name=module.params["tenant_space"],
            placement_group_name=module.params["placement_group"],
        )
    except purefusion.rest.ApiException:
        return None


def get_protection_policy(module, fusion):
    """Return Protection Policy or None"""
    pp_api_instance = purefusion.ProtectionPoliciesApi(fusion)
    try:
        return pp_api_instance.get_protection_policy(
            protection_policy_name=module.params["protection_policy"]
        )
    except purefusion.rest.ApiException:
        return None


def get_all_haps(fusion):
    """Return set of all existing host access policies or None"""
    hap_api_instance = purefusion.HostAccessPoliciesApi(fusion)
    all_haps = hap_api_instance.list_host_access_policies()
    return set([hap.name for hap in all_haps.items])


def get_wanted_haps(module):
    """Return set of host access policies to assign"""
    if not module.params["host_access_policies"]:
        return set()
    # looks like yaml parsing can leave in some spaces if coma-delimited .so strip() the names
    return set([hap.strip() for hap in module.params["host_access_policies"]])


def extract_current_haps(volume):
    """Return set of host access policies that volume currently has"""
    if not volume.host_access_policies:
        return set()
    return set([hap.name for hap in volume.host_access_policies])


def create_volume(module, fusion):
    """Create Volume"""

    size = parse_number_with_metric_suffix(module, module.params["size"])

    if not module.check_mode:
        if not module.params["display_name"]:
            display_name = module.params["name"]
        else:
            display_name = module.params["display_name"]
        volume_api_instance = purefusion.VolumesApi(fusion)
        volume = purefusion.VolumePost(
            size=size,
            storage_class=module.params["storage_class"],
            placement_group=module.params["placement_group"],
            name=module.params["name"],
            display_name=display_name,
            protection_policy=module.params["protection_policy"],
        )
        op = volume_api_instance.create_volume(
            volume,
            tenant_name=module.params["tenant"],
            tenant_space_name=module.params["tenant_space"],
        )
        await_operation(fusion, op)

    return True


def update_host_access_policies(module, fusion, current, patches):
    wanted = module.params
    # 'wanted[...] is not None' to differentiate between empty list and no list
    if wanted["host_access_policies"] is not None:
        current_haps = extract_current_haps(current)
        wanted_haps = get_wanted_haps(module)
        if wanted_haps != current_haps:
            patch = purefusion.VolumePatch(
                host_access_policies=purefusion.NullableString(",".join(wanted_haps))
            )
            patches.append(patch)


def update_destroyed(module, fusion, current, patches):
    wanted = module.params
    destroyed = wanted["state"] != "present"
    if destroyed != current.destroyed:
        patch = purefusion.VolumePatch(destroyed=purefusion.NullableBoolean(destroyed))
        patches.append(patch)
        if destroyed and not module.params["eradicate"]:
            module.warn(
                (
                    "Volume '{0}' is being soft deleted to prevent data loss, "
                    "if you want to wipe it immediately to reclaim used space, add 'eradicate: true'"
                ).format(current.name)
            )


def update_display_name(module, fusion, current, patches):
    wanted = module.params
    if wanted["display_name"] and wanted["display_name"] != current.display_name:
        patch = purefusion.VolumePatch(
            display_name=purefusion.NullableString(wanted["display_name"])
        )
        patches.append(patch)


def update_storage_class(module, fusion, current, patches):
    wanted = module.params
    if (
        wanted["storage_class"]
        and wanted["storage_class"] != current.storage_class.name
    ):
        patch = purefusion.VolumePatch(
            storage_class=purefusion.NullableString(wanted["storage_class"])
        )
        patches.append(patch)


def update_placement_group(module, fusion, current, patches):
    wanted = module.params
    if (
        wanted["placement_group"]
        and wanted["placement_group"] != current.placement_group.name
    ):
        patch = purefusion.VolumePatch(
            placement_group=purefusion.NullableString(wanted["placement_group"])
        )
        patches.append(patch)


def update_size(module, fusion, current, patches):
    wanted = module.params
    if wanted["size"]:
        wanted_size = parse_number_with_metric_suffix(module, wanted["size"])
        if wanted_size != current.size:
            patch = purefusion.VolumePatch(size=purefusion.NullableSize(wanted_size))
            patches.append(patch)


def update_protection_policy(module, fusion, current, patches):
    wanted = module.params
    current_policy = current.protection_policy.name if current.protection_policy else ""
    if (
        wanted["protection_policy"] is not None
        and wanted["protection_policy"] != current_policy
    ):
        patch = purefusion.VolumePatch(
            protection_policy=purefusion.NullableString(wanted["protection_policy"])
        )
        patches.append(patch)


def apply_patches(module, fusion, patches):
    volume_api_instance = purefusion.VolumesApi(fusion)
    for patch in patches:
        op = volume_api_instance.update_volume(
            patch,
            volume_name=module.params["name"],
            tenant_name=module.params["tenant"],
            tenant_space_name=module.params["tenant_space"],
        )
        await_operation(fusion, op)


def update_volume(module, fusion):
    """Update Volume size, placement group, protection policy, storage class, HAPs"""
    current = get_volume(module, fusion)
    patches = []

    if not current:
        # cannot update nonexistent volume
        # Note for check mode: the reasons this codepath is ran in check mode
        # is to catch any argument errors and to compute 'changed'. Basically
        # all argument checks are kept in validate_arguments() to filter the
        # first part. The second part MAY diverge flow from the real run here if
        # create_volume() created the volume and update was then run to update
        # its properties. HOWEVER we don't really care in that case because
        # create_volume() already sets 'changed' to true, so any 'changed'
        # result from update_volume() would not change it.
        return False

    # volumes with 'destroyed' flag are kinda special because we can't change
    # most of their properties while in this state, so we need to set it last
    # and unset it first if changed, respectively
    if module.params["state"] == "present":
        update_destroyed(module, fusion, current, patches)
        update_size(module, fusion, current, patches)
        update_protection_policy(module, fusion, current, patches)
        update_display_name(module, fusion, current, patches)
        update_storage_class(module, fusion, current, patches)
        update_placement_group(module, fusion, current, patches)
        update_host_access_policies(module, fusion, current, patches)
    elif module.params["state"] == "absent" and not current.destroyed:
        update_size(module, fusion, current, patches)
        update_protection_policy(module, fusion, current, patches)
        update_display_name(module, fusion, current, patches)
        update_storage_class(module, fusion, current, patches)
        update_placement_group(module, fusion, current, patches)
        update_host_access_policies(module, fusion, current, patches)
        update_destroyed(module, fusion, current, patches)

    if not module.check_mode:
        apply_patches(module, fusion, patches)

    changed = len(patches) != 0
    return changed


def eradicate_volume(module, fusion):
    """Eradicate Volume"""
    current = get_volume(module, fusion)
    if module.check_mode:
        return current or module.params["state"] == "present"
    if not current:
        return False

    # update_volume() should be called before eradicate=True and it should
    # ensure the volume is destroyed and HAPs are unassigned
    if not current.destroyed or current.host_access_policies:
        module.fail_json(
            msg="BUG: inconsistent state, eradicate_volume() cannot be called with current.destroyed=False or any host_access_policies"
        )

    volume_api_instance = purefusion.VolumesApi(fusion)
    op = volume_api_instance.delete_volume(
        volume_name=module.params["name"],
        tenant_name=module.params["tenant"],
        tenant_space_name=module.params["tenant_space"],
    )
    await_operation(fusion, op)

    return True


def validate_arguments(module, fusion):
    """Validates most argument conditions and possible unacceptable argument combinations"""
    volume = get_volume(module, fusion)
    state = module.params["state"]

    if state == "present" and not volume:
        module.fail_on_missing_params(["placement_group", "storage_class", "size"])

    if module.params["placement_group"] and not get_protection_group(module, fusion):
        module.fail_json(
            msg="Placement Group '{0}' does not exist in the provided "
            "tenant and tenant name space".format(module.params["placement_group"])
        )

    if module.params["storage_class"] and not get_storage_class(module, fusion):
        module.fail_json(
            msg="Storage Class '{0}' does not exist".format(
                module.params["storage_class"]
            )
        )

    if module.params["protection_policy"] and not get_protection_policy(module, fusion):
        module.fail_json(
            msg="Protection Policy '{0}' does not exist".format(
                module.params["protection_policy"]
            )
        )

    if module.params["host_access_policies"] is not None:
        existing_haps = get_all_haps(fusion)
        wanted_haps = get_wanted_haps(module)
        if not (wanted_haps <= existing_haps):
            module.fail_json(
                msg="To-be-assigned host access policies '{0}' don't exist".format(
                    wanted_haps - existing_haps
                )
            )

    if module.params["state"] == "absent" and (
        module.params["host_access_policies"]
        or (
            module.params["host_access_policies"] is None
            and volume.host_access_policies
        )
    ):
        module.fail_json(
            msg=(
                "Volume must have no host access policies when destroyed, either revert the delete "
                "by setting 'state: present' or remove all HAPs by 'host_access_policies: []'"
            )
        )

    if state == "present" and module.params["eradicate"]:
        module.fail_json(
            msg="'eradicate: true' cannot be used together with 'state: present'"
        )

    if state == "present" and not volume:
        # would create a volume; check size is lower than storage class limit
        # (let resize checks be handled by the server since they are more complicated)
        size = parse_number_with_metric_suffix(module, module.params["size"])
        size_limit = get_storage_class(module, fusion).size_limit
        if size > size_limit:
            module.fail_json(
                msg="Requested volume size {0} exceeds the storage class limit of {1}".format(
                    module.params["size"],
                    print_number_with_metric_suffix(size_limit),
                )
            )


def main():
    """Main code"""
    argument_spec = fusion_argument_spec()
    deprecated_hosts = dict(
        name="hosts", date="2023-07-26", collection_name="purefusion.fusion"
    )
    argument_spec.update(
        dict(
            name=dict(type="str", required=True),
            display_name=dict(type="str"),
            rename=dict(
                type="str",
                removed_at_date="2023-07-26",
                removed_from_collection="purestorage.fusion",
            ),
            tenant=dict(type="str", required=True),
            tenant_space=dict(type="str", required=True),
            placement_group=dict(type="str"),
            storage_class=dict(type="str"),
            protection_policy=dict(type="str"),
            host_access_policies=dict(
                type="list", elements="str", deprecated_aliases=[deprecated_hosts]
            ),
            eradicate=dict(type="bool", default=False),
            state=dict(type="str", default="present", choices=["absent", "present"]),
            size=dict(type="str"),
        )
    )

    required_by = {
        "placement_group": "storage_class",
    }

    module = AnsibleModule(
        argument_spec,
        required_by=required_by,
        supports_check_mode=True,
    )
    fusion = setup_fusion(module)

    state = module.params["state"]

    volume = get_volume(module, fusion)

    validate_arguments(module, fusion)

    if state == "absent" and not volume:
        module.exit_json(changed=False)

    changed = False
    if state == "present" and not volume:
        changed = changed | create_volume(module, fusion)
    # volume might exist even if soft-deleted, so we still have to update it
    changed = changed | update_volume(module, fusion)
    if module.params["eradicate"]:
        changed = changed | eradicate_volume(module, fusion)

    module.exit_json(changed=changed)


if __name__ == "__main__":
    main()
