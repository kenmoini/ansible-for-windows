#!/usr/bin/python
# -*- coding: utf-8 -*-

# This file is part of Ansible
#
# Ansible is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Ansible is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Ansible.  If not, see <http://www.gnu.org/licenses/>.

# this is a windows documentation stub. actual code lives in the .ps1
# file of the same name

# https://docs.microsoft.com/en-us/powershell/module/hyper-v/new-vhd?view=windowsserver2022-ps

DOCUMENTATION = '''
---
module: win_hyperv_vhd
version_added: "2.5"
short_description: Adds, deletes and performs configuration of Hyper-V Virtual Hard Drives (VHDX).
description:
    - Adds, deletes and performs configuration of Hyper-V Virtual Hard Drives (VHDX).
options:
  path:
    description:
      - Path to the VHDX file
    required: true
  state:
    description:
      - State of the VHDX file
    required: false
    choices:
      - present
      - absent
    default: present
  size:
    description:
      - Size of the VHDX file
    required: false
    default: null
  cloneVHD:
    description:
      - Path to the source disk if being cloned
    required: false
    default: null
  dynamicExpansion:
    description:
      - Specifies whether the VHDX file is expandable. Mutually exclusive with fixedSize.
    required: false
    default: true
  fixedSize:
    description:
      - Specifies whether the VHDX file is fixed.  Mutually exclusive with dynamicExpansion.
    required: false
    default: null
'''

EXAMPLES = '''
  # Create VHD with size of 120GB with dynamic expansion
  win_hyperv_vhd:
    path: C:\Temp\my_vhd.vhdx
    state: present
    size: 120GB
    dynamicExpansion: true

  # Delete a VHD
  win_hyperv_vhd:
    name: C:\Temp\my_vhd.vhdx
    state: absent

  # Create a fixed size VHD with size of 100GB
  win_hyperv_vhd:
    path: C:\Temp\my_fixed_vhd.vhdx
    state: present
    size: 120GB
    fixed: true

  # Clone a VHD
  win_hyperv_vhd:
    path: C:\Temp\my_cloned_vhd.vhdx
    state: present
    cloneVHD: C:\Temp\my_original_vhd.vhdx
'''

ANSIBLE_METADATA = {
    'status': ['preview'],
    'supported_by': 'community',
    'metadata_version': '1.1'
}
