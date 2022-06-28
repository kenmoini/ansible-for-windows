#!powershell
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

# WANT_JSON
# POWERSHELL_COMMON

#Requires -Module Ansible.ModuleUtils.Legacy
Set-StrictMode -Version 2

#########################################################################################################################################
# Functions
#########################################################################################################################################

Function VHD-Create {
  #Check If the VirtualSwitch already exists
  $CheckVHD = Get-VHD -Path $path -ErrorAction SilentlyContinue
  
  if (!$CheckVHD) {
    
    if (!$cloneVHD) {
      $cmd = "New-VHD -Path '$path'"
      
      if ($size) {
        $cmd += " -SizeBytes $size"
      }
      
      if ($dynamicExpansion) {
        if ($dynamicExpansion -eq $true) {
          $cmd += " -Dynamic"
        }
      }
      
      if ($fixedSize) {
        if ($fixedSize -eq $true) {
          $cmd += " -Fixed"
        }
      }
    } else {
      # Just copy the file over lol
      # Check to make sure the cloneVHD path file exists
      if (Test-Path -Path $cloneVHD -PathType Leaf) {
        $cmd = "Copy-Item '$cloneVHD' -Destination '$path'"
      } else {
        Fail-Json $result "The cloneVHD path does not exist"
      }
    }
    
    $result.cmd_used = $cmd
    $result.changed = $true
    
    if (!$check_mode) {
      $results = invoke-expression -Command "$cmd"
    }
  } else {
    $result.changed = $false
  }
}

Function VHD-Delete {
  $CheckVHD = Get-VHD -path $path -ErrorAction SilentlyContinue
  
  if ($CheckVHD) {
    $cmd="Remove-Item -Path $path -Force"
    $result.cmd_used = $cmd
    $result.changed = $true

    if (!$check_mode) {
      $results = invoke-expression $cmd
    }
  } else {
    $result.changed = $false
  }
}

#########################################################################################################################################
# Parameter Setup
#########################################################################################################################################

$params = Parse-Args $args -supports_check_mode $true
$check_mode = Get-AnsibleParam -obj $params -name "_ansible_check_mode" -type "bool" -default $false
$result = @{
  changed = $false
  cmd_used = ""
}

$debug_level = Get-AnsibleParam -obj $params -name "_ansible_verbosity" -type "int"
$debug = $debug_level -gt 2

$state = Get-AnsibleParam $params "state" -type "str" -FailIfEmpty $true -emptyattributefailmessage "missing required argument: state"
$path = Get-AnsibleParam $params "path" -type "str" -FailIfEmpty $true -emptyattributefailmessage "missing required argument: path"
$size = Get-AnsibleParam $params "size" -type "str" -Default $null

$cloneVHD = Get-AnsibleParam $params "cloneVHD" -type "str" -Default $null
$dynamicExpansion = Get-AnsibleParam $params "dynamicExpansion" -type "bool" -Default $null
$fixedSize = Get-AnsibleParam $params "fixedSize" -type "bool" -Default $null

#########################################################################################################################################
# State Action Switches
#########################################################################################################################################

Try {
  switch ($state) {
    "present" {VHD-Create}
    "absent" {VHD-Delete}
  }
  Exit-Json $result;
} Catch {
  Fail-Json $result $_.Exception.Message
}
