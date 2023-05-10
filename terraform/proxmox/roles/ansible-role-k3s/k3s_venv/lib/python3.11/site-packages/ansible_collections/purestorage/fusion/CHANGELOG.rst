================================
Purestorage.Fusion Release Notes
================================

.. contents:: Topics


v1.4.2
======

Minor Changes
-------------

- added Python package dependency checks in prerequisites.py
- fusion_hap - added missing "windows" personality type

Bugfixes
--------

- fusion_array - correct required parameters
- fusion_hap - display name has now default value set to the value of name
- fusion_hw - correct required parameters
- fusion_pg - correct required parameters
- fusion_pp - correct required parameters
- fusion_sc - correct required parameters
- fusion_ss - allow updating hardware types, correct required parameters
- fusion_tn - fix attribute error
- fusion_volume - protection policy can now be unset by using "" as name

v1.4.1
======

v1.4.0
======

Major Changes
-------------

- Patching of resource properties was brought to parity with underlying Python SDK, meaning the collection can create/update/delete all resource properties the SDK can
- fusion_volume - fixed and reorganized, arguments changed

Minor Changes
-------------

- errors_py - added opt-in global exception handler which produces simpler and cleaner messages on REST errors
- removed dependency on Python `netaddr` package

Deprecated Features
-------------------

- fusion_hw - hardware module is being removed as changing hardware type has never been supported by Pure Storage Fusion
- fusion_info - nigs subset is deprecated in favor of network_interface_groups and will be removed in the version 1.7.0 (https://github.com/Pure-Storage-Ansible/Fusion-Collection/pull/46).
- fusion_info - placements subset is deprecated in favor of placement_groups and will be removed in the version 1.7.0 (https://github.com/Pure-Storage-Ansible/Fusion-Collection/pull/62).
- fusion_pg - placement_engine option is deprecated because Fusion API does not longer support this parameter It will be removed in the version 2.0.0 (https://github.com/Pure-Storage-Ansible/Fusion-Collection/pull/53).
- fusion_se - parameters "addresses", "gateway" and "network_interface_groups" are deprecated in favor of "iscsi" and will be removed in version 2.0.0
- fusion_tn - tenant networks are being replaced by storage endpoints ```fusion_se``` and Network Interface Groups ```fusion_nig```

Bugfixes
--------

- fusion_api_client - error messages now mostly handled by errors_py
- fusion_hap - could not delete host access policy without iqn option. Now it needs only name option for deletion (https://github.com/Pure-Storage-Ansible/Fusion-Collection/pull/55)
- fusion_hap - error messages now mostly handled by errors_py
- fusion_hap - uppercase names were not supported. Now uppercase names are allowed (https://github.com/Pure-Storage-Ansible/Fusion-Collection/pull/55)
- fusion_info - fixes typo in output 'appiiances' -> 'appliances'
- fusion_info - network_interface_groups subset returned nothing. Now it collects the same information as nigs subset (https://github.com/Pure-Storage-Ansible/Fusion-Collection/pull/46).
- fusion_info - placements subset returned nothing. Now it collects the same information as placement_groups subset (https://github.com/Pure-Storage-Ansible/Fusion-Collection/pull/62).
- fusion_nig - add missing 'availability_zone' format param in error message
- fusion_nig - error messages now mostly handled by errors_py
- fusion_pg - create_pg always broke runtime. Now it executes and creates placement group successfully (https://github.com/Pure-Storage-Ansible/Fusion-Collection/pull/53).
- fusion_pg - error messages now mostly handled by errors_py
- fusion_pp - error messages now mostly handled by errors_py
- fusion_pp - fix call to parse_minutes where we were missing a required argument
- fusion_sc - error messages now mostly handled by errors_py
- fusion_se - add missing 'availability_zone' format param in error message
- fusion_se - error messages now mostly handled by errors_py
- fusion_se - fix call in get_nifg where provider_subnet was used instead of network_interface_group_name
- fusion_ss - error messages now mostly handled by errors_py
- fusion_tenant - error messages now mostly handled by errors_py
- fusion_ts - add missing 'tenant' format param in error message
- fusion_ts - error messages now mostly handled by errors_py
- fusion_volume - error messages now mostly handled by errors_py

v1.3.0
======

Bugfixes
--------

- fusion_pg - Add missing 'region' parameter
- fusion_tn - Add missing 'region' parameter

v1.2.0
======

Minor Changes
-------------

- fusion_info - Added API Client information

Bugfixes
--------

- fusion_info - Fixed issue with storage endpoint dict formatting

v1.1.1
======

v1.1.0
======

Minor Changes
-------------

- fusion_az - Add delete AZ option
- fusion_az - Allow any region to be specificed instead of limited to a known list
- fusion_pp - Add delete PP option
- fusion_sc - Add delete SC option
- fusion_ss - Add delete SS option

Bugfixes
--------

- Allow correct use of environmental variables for App ID and private file file

New Modules
-----------

- purestorage.fusion.fusion_region - Manage Regions in Pure Storage Fusion

v1.0.3
======

v1.0.2
======

v1.0.1
======

v1.0.0
======

New Modules
-----------

- purestorage.fusion.fusion_api_client - Manage API clients in Pure Storage Fusion
- purestorage.fusion.fusion_array - Manage arrays in Pure Storage Fusion
- purestorage.fusion.fusion_az - Create Availability Zones in Pure Storage Fusion
- purestorage.fusion.fusion_hap - Manage host access policies in Pure Storage Fusion
- purestorage.fusion.fusion_hw - Create hardware types in Pure Storage Fusion
- purestorage.fusion.fusion_info - Collect information from Pure Fusion
- purestorage.fusion.fusion_nig - Manage Network Interface Groups in Pure Storage Fusion
- purestorage.fusion.fusion_pg - Manage placement groups in Pure Storage Fusion
- purestorage.fusion.fusion_pp - Manage protection policies in Pure Storage Fusion
- purestorage.fusion.fusion_ra - Manage role assignments in Pure Storage Fusion
- purestorage.fusion.fusion_sc - Manage storage classes in Pure Storage Fusion
- purestorage.fusion.fusion_ss - Manage storage services in Pure Storage Fusion
- purestorage.fusion.fusion_tenant - Manage tenants in Pure Storage Fusion
- purestorage.fusion.fusion_tn - Manage tenant networks in Pure Storage Fusion
- purestorage.fusion.fusion_ts - Manage tenant spaces in Pure Storage Fusion
- purestorage.fusion.fusion_volume - Manage volumes in Pure Storage Fusion
