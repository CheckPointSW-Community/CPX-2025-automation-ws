# CPX-2025-automation-ws
Check Point Autmation workshop at CPX 2025, allowing engineers to get hands-on experience on the Check Point management API and the integration with Terraform and Ansible

## Connect to the environment
1. Open the provided link and go to the tab “Windows Client” in CloudShare.
<br><img width="469" alt="image" src="https://github.com/user-attachments/assets/fd5dfee3-08f5-434d-bf5b-0f2d418aec7f" />

2. On "Windows Client" click on "Reload Window" to allow Visual Studio Code to reconnect to the Orchestration Server
<br><img width="234" alt="image" src="https://github.com/user-attachments/assets/8907b756-a18d-4711-9b7b-1010bd80f916" />

3. In Visual Studio Code right click on the README.md file and select "Open Preview"
<br><img width="369" alt="image" src="https://github.com/user-attachments/assets/3c78d293-4f31-4622-af6a-a0d580e1f571" />


## Lab 1 - Build simple Check Point policy with IAC using Terraform  

### Prepare the environment
1. In this environment we stored the login information in these environmental variables 
   * CHECKPOINT_API_KEY 
   * CHECKPOINT_SERVER

2. Review that the environmental variables contains the necessary values by executing the following command in visual studio code terminal session connected to the orchestration server
```bash
printenv CHECKPOINT_API_KEY
printenv CHECKPOINT_SERVER
```
<br><img width="469" alt="image" src="https://github.com/user-attachments/assets/14d425c0-5427-4930-a2a8-0a1b3c05c4c4" />

3. Use the browser to go to Web SmartConsole **"admin/Cpwins1!"**, review the current policy packages and verify that there are no host objects
<br><img width="469" alt="image" src="https://github.com/user-attachments/assets/6fd22204-d8df-458a-836a-232258c70962" />


### Deploy the policy
You are now ready to deploy the policy using terraform

1. Change to the 01-terraform folder
```bash
cd ~/CPX-2025-automation-ws/01-terraform
```
2. Run `terraform init` to download the provider and initialize the coresponding modules
3. Run `terraform apply` and look at the plan and the 33 changes that will be made
4. Accept by answering **yes**

5. Run `terraform apply` again and see that there will be no changes made since your security infrastructure matches your configuration
<br>You should see the following:
<br><img width="469" alt="image" src="https://github.com/user-attachments/assets/77e7f39b-6d10-4b34-b235-0902d4ddba48" />

### Review changes applied by Terraform
1. Go to Web SmartConsole **"admin/Cpwins1!"**, review some of the changes applied by terraform.
<br><img width="469" alt="image" src="https://github.com/user-attachments/assets/0e090de5-9a2e-4bd2-ba20-3b7edb6ab2de" />

**Done**: Go to next lab in 02-ansible folder by executing this command
```bash
cd ~/CPX-2025-automation-ws/02-ansible/
```
## Lab 2 - Build and maintain an enterprise Check Point policy with IAC using Ansible   

### Add latest Check Point management ansible collection
As per installation instructions "https://galaxy.ansible.com/ui/repo/published/check_point/mgmt/" install the collection with this command
```bash
ansible-galaxy collection install check_point.mgmt
```
If you get an notification that "Nothing to do. All requested collections are already installed" run the install of the collection again using `--force`
```bash
ansible-galaxy collection install check_point.mgmt --force
```

### Deploy the enterprise policy using Ansible

You are now ready to deploy and maintain an enterprise policy using ansible
1. Review inventory.yml. 
<br>As you can see we are using the environment variables coming from to authenticate.
<br>The below command will open the file in Visual Studio code 
```bash
code ~/CPX-2025-automation-ws/02-ansible/inventory.ini
```

2. Deploy an enterprise policy from this playbook myobject-playbook.yml via ansible using the following command:
```bash
ansible-playbook demo-policy-playbook.yml -i inventory.yml
```

Use the Browser to go to Web SmartConsole **"admin/Cpwins1!"**, see the changes applied by Ansible. 
You should see new gateways as well as a Branch office and Corporate policy similar to SmartConsole demo mode

Re-run the ansible command, you will see that the modules are **idempotent**, as your ansible code is equal to the reality no change is made and ansible responds with ok: [R82mgmt] for each task except for the publish task.
```bash
ansible-playbook demo-policy-playbook.yml -i inventory.yml
```

### Create you own object using ansible
To save some time we will use another playbook file in order not run through all the tasks again.

Open the file **myobjects/main.yml** and review the code in there
```bash
# The below command will open the file in Visual Studio code 
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
**Note:** ```auto_publish_session: true``` will publish the changes for this task when it is being executed

Run the playbook myobject-playbook.yml
```bash
ansible-playbook myobject-playbook.yml -i inventory.yml
```
Go to  Web Smart Console **"admin/Cpwins1!"**, see the changes applied by Ansible.

Change the color to your object in **myobjects/main.yml** and re-run the playbook, notice that the status reported for the task is "changed: [mgmt]".

Go to Web Smart Console **"admin/Cpwins1!"**, see the changes applied by Ansible.

Set the state of the object in **myobjects/main.yml** to absent
```yaml
state: absent 
```
Re-run the playbook myobject-playbook.yml
```bash
ansible-playbook myobject-playbook.yml -i inventory.yml
```

Go to Web Smart Console **"admin/Cpwins1!"**, check what happened with your object.
<br>What does `state: absent` mean?

If you have some spare time you can go to https://galaxy.ansible.com/ui/repo/published/check_point/mgmt/docs/, pick an example from the list and try to create that object with Ansible.

## Resources:
- [sk121360 - Check Point APIs homepage](https://support.checkpoint.com/results/sk/sk121360)
- [Check Point API Reference Guide](https://sc1.checkpoint.com/documents/latest/api_reference/index.html)
- [Check Point AI Copilot](https://support.checkpoint.com/ai)
- [Check Point Management Terraform Provider](https://registry.terraform.io/providers/CheckPointSW/checkpoint/latest/docs)
- [Check Point Ansible collection for the Management Server](https://galaxy.ansible.com/ui/repo/published/check_point/mgmt/)
- [Check Point Smart-1 Cloud](https://sc1.checkpoint.com/documents/Infinity_Portal/WebAdminGuides/EN/Check-Point-SmartCloud-Admin-Guide/Topics-Smart-1-Cloud/Overview.htm)


- [Github Codespaces](https://github.com/codespaces)
- [VScode](https://code.visualstudio.com/)
