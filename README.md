# CPX-2025-automation-ws
Check Point Autmation workshop at CPX 2025, allowing engineers to get hands-on experience on the Check Point management API and the integration with Terraform and Ansible

## Connect to the environment
1. Open the provided link and go to the tab “**Windows Client**” in CloudShare.
2. On "**Windows Client**" click on "**Reload Window**" to allow Visual Studio Code to reconnect to the Orchestration Server
<br><img width="469" alt="image" src="https://github.com/user-attachments/assets/b9d6a66c-39bf-4bd9-86e5-e96583f1558b" />

3. Follow the instructions in the open **README.md** in Visual Studio Code

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

### Review Terraform configuration
1. Review **main.tf** terraform configuration file, as you can we are two aliases for the provide configuration allowing us to login to diffrent domains in the management server in one terraform run.
<br>The code block `module "admins" {` points to the folder **system-data** containig the terraform configuration to create an admin
<br>The code block `module "policy" {` points to the folder **policy** containig the terraform configuration to create the Security Policy
<br>In the **checkpoint_management_publish** code blocks you can see that it is configured to trigger when there is a configuration change on the files in the folders system-data and policy, as well as forcing it to run on terrraform destroy actions.
<br>The below command will open the **~/CPX-2025-automation-ws/01-terraform/main.tf** file in Visual Studio code 
```bash
code ~/CPX-2025-automation-ws/01-terraform/main.tf
```

2. Review **admins.tf**, terraform configuration file and review the code block to create a adminstrator,
<br>The below command will open the file in **~/CPX-2025-automation-ws/01-terraform/system-data/admins.tf** Visual Studio code 
```bash
code ~/CPX-2025-automation-ws/01-terraform/system-data/admins.tf
```

3. Review **hosts.tf**, terraform configuration file and review the code block to add host objects to the security configuration,
<br>The below command will open the file in **~/CPX-2025-automation-ws/01-terraform/01-terraform/policy/hosts.tf** Visual Studio code 
```bash
code ~/CPX-2025-automation-ws/01-terraform/01-terraform/policy/hosts.tf
```

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

### Change your Terraform configuration and review the changes
1. Open **hosts.tf**, terraform configuration and change the color of the host object **azure_lb_health_check** to **red**
<br>The below command will open the file in **~/CPX-2025-automation-ws/01-terraform/01-terraform/policy/hosts.tf** Visual Studio code 
```bash
code ~/CPX-2025-automation-ws/01-terraform/01-terraform/policy/hosts.tf
```
2. Run `terraform apply`, look at the plan and try to understand what changes terraform will make
3. Accept by answering **yes**
4. Go to Web SmartConsole **"admin/Cpwins1!"**, and see if the collor of the host objecy has changed.

### Destroy a Terraform resourse and review the changes
1. Open **hosts.tf**, terraform configuration and remove the code block for the resource "**azurelbhealthcheck**"
<br>The below command will open the file in **~/CPX-2025-automation-ws/01-terraform/01-terraform/policy/hosts.tf** Visual Studio code 
```bash
code ~/CPX-2025-automation-ws/01-terraform/01-terraform/policy/hosts.tf
```
2. Run `terraform apply`, look at the plan and try to understand what changes terraform will make
3. Accept by answering **yes**
4. Go to Web SmartConsole **"admin/Cpwins1!"**, and verify that the host object has been removed

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
1. Review **inventory.yml**, as you can see we are using the environment variables to authenticate.
<br>The below command will open the **~/CPX-2025-automation-ws/02-ansible/inventory.yml** file in Visual Studio code 
```bash
code ~/CPX-2025-automation-ws/02-ansible/inventory.yml
```

2. Deploy an enterprise policy from this playbook **myobject-playbook.yml** via ansible using the following command:
```bash
ansible-playbook demo-policy-playbook.yml -i inventory.yml
```
3. Use the Browser to go to Web SmartConsole **"admin/Cpwins1!"**, see the changes applied by Ansible. 
<br>You should see new gateways as well as a Branch office and Corporate policy similar to SmartConsole demo mode:
<br><img width="469" alt="image" src="https://github.com/user-attachments/assets/0b417594-5cd5-4244-b17e-05909615f5fa" />

### Create and change youre own object using ansible
To save some time we will use another playbook file in order not run through all the tasks again.

1. Open the file **myobjects/main.yml** and review the code in there
<br>The below command will open the **~/CPX-2025-automation-ws/02-ansible/myobjects/main.yml** file in Visual Studio code
```bash 
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

2. Run the playbook **myobject-playbook.yml**
```bash
ansible-playbook myobject-playbook.yml -i inventory.yml
```
Go to  Web Smart Console **"admin/Cpwins1!"**, see the changes applied by Ansible.
<br>![image](https://github.com/user-attachments/assets/4bc15524-1d4d-4e21-9ea7-dec2d867483c)

3. Re-run the playbook **myobject-playbook.yml**, you will see that the modules are **idempotent**. Since your ansible code is equal to the reality. no change is made and ansible responds with ok
```bash
ansible-playbook myobject-playbook.yml -i inventory.yml
```
![image](https://github.com/user-attachments/assets/173dea57-bcab-4ecc-9eb3-188875f48977)

4. Change the color to your object in **myobjects/main.yml** and re-run the playbook, notice that the status reported for the task is "changed: [R82mgmt]".

5. Go to Web Smart Console **"admin/Cpwins1!"**, see the changes applied by Ansible.

6. Set the state of the object in **myobjects/main.yml** to absent
```yaml
state: absent 
```
7. Re-run the playbook myobject-playbook.yml 
```bash
ansible-playbook myobject-playbook.yml -i inventory.yml
```

8. Go to Web Smart Console **"admin/Cpwins1!"**, check what happened with your object.
<br>What does `state: absent` mean?

**Done**: If you have some spare time you can go to https://galaxy.ansible.com/ui/repo/published/check_point/mgmt/docs/, pick an example from the list and try to create that object with Ansible, or make some changes to your terraform configuration to see what happens.

## Resources:
- [sk121360 - Check Point APIs homepage](https://support.checkpoint.com/results/sk/sk121360)
- [Check Point API Reference Guide](https://sc1.checkpoint.com/documents/latest/api_reference/index.html)
- [Check Point AI Copilot](https://support.checkpoint.com/ai)
- [Check Point Management Terraform Provider](https://registry.terraform.io/providers/CheckPointSW/checkpoint/latest/docs)
- [Check Point Ansible collection for the Management Server](https://galaxy.ansible.com/ui/repo/published/check_point/mgmt/)
- [Github - Check Point Software Technologies Ltd.](https://github.com/checkpointsw)
- [Github - Check Point CheckMates Community](https://github.com/checkpointsw-community)
- [CheckMates - API / CLI Discussion](https://community.checkpoint.com/t5/API-CLI-Discussion/bd-p/codehub)
- - [CheckMates - Ansible Discussion](https://community.checkpoint.com/t5/Ansible/bd-p/ansible)
- [Check Point Smart-1 Cloud](https://sc1.checkpoint.com/documents/Infinity_Portal/WebAdminGuides/EN/Check-Point-SmartCloud-Admin-Guide/Topics-Smart-1-Cloud/Overview.htm)
- [Github Codespaces](https://github.com/codespaces)
- [VScode](https://code.visualstudio.com/)
