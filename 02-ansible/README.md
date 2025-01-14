## Lab 2 - Build and maintain an enterpise Check Point policy with IAC using Ansible   

### Add latest Check Point management ansible collection
As the installation instructions per https://galaxy.ansible.com/ui/repo/published/check_point/mgmt/ install the collection with this command
```bash
ansible-galaxy collection install check_point.mgmt
```
If you get an notification that "Nothing to do. All requested collections are already installed" run the install of the collection again using `--force`

### Deploy the entprise policy using Ansible

You are now ready to deploy and maintain a enterpise policy using ansible
```bash
# Enter this folder
cd ~/CPX-2025-automation-ws/02-ansible

# Review inventory.yml. 
# As you can see we are using the enviromental varibles comming from to authenticate.
# The below comand will open the file in Visual Studio code 
code ~/CPX-2025-automation-ws/02-ansible/inventory.ini

# Deploy an enterprize policy from this playbook myobject-playbook.yml via ansible using the following command:
ansible-playbook demo-policy-playbook.yml -i inventory.yml
```

Go to the Web based Smart Console and see the changes applied by Ansible. 
You should see new gateways as well as a Branch office and Corporate policy similar to SmartConsole demo mode

Re-run the ansible command, you will see that the modules a idemopotent, as your ansible code is equal to the reality no change is made and ansible responds with ok: [R82mgmt] for each task except for the publish task.
```bash
ansible-playbook demo-policy-playbook.yml -i inventory.yml
```

### Create you own object using ansible
To save some time we will use another playbook file in order not run through all the tasks again.

Open the file **myobjects/main.yml** and review the code in there
```bash
# The below comand will open the file in Visual Studio code 
code ~/CPX-2025-automation-ws/02-ansible/myobjects/main.yml
```

In the example we are creating a VPN community of type meshed with color red:
```yaml
- name: add-vpn-community-meshed
  cp_mgmt_vpn_community_meshed:
    name: Jims VPN Community by Ansible
    state: present
    color: red
    encryption_method: prefer ikev2 but support ikev1
    encryption_suite: custom
    ike_phase_1:
      data_integrity: sha1
      diffie_hellman_group: group-19
      encryption_algorithm: aes-128
    ike_phase_2:
      data_integrity: aes-xcbc
      encryption_algorithm: aes-gcm-128
    auto_publish_session: true
```
**Note:** ```auto_publish_session: true``` will publish the changes for this task when it is beeing executed

Run the playbook myobject-playbook.yml
```bash
ansible-playbook myobject-playbook.yml -i inventory.yml
```
Go to the Web based Smart Console in Smart-1 Cloud and see the changes applied by Ansible.

Change the color to your object in **myobjects/main.yml** and re-run the playbook, notice that the status reported for the task is "changed: [mgmt]".

Go to the Web based Smart Console and see the changes applied by Ansible.

Set the state of the object in **myobjects/main.yml** to absent
```yaml
state: absent 
```
Go to the Web based Smart Console and check what happened with your object.
<br>What does state: absent mean?

If you have some spare time you can go to "https://galaxy.ansible.com/ui/repo/published/check_point/mgmt/docs/", pick an example from the list and try to create that object with Ansible.