# Ansible for Windows Examples

## Prerequisites

- Install pip modules: `python3 -m pip install --upgrade -r requirements.txt`
- Install Ansible Collections: `ansible-galaxy collection install -r ./collections/requirements.yml`
- Modify the inventory to meet your environment
- Bootstrap the target Windows Servers/Workstations with WinRM: `Invoke-Expression ((New-Object System.Net.Webclient).DownloadString('https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1'))`


## Running the Playbook

`ansible-playbook -i inventory bootstrap-server.yaml`
`ansible-playbook -i inventory create-vm.yaml`
