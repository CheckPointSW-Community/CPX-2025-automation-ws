# CPX-2025-automation-ws
Check Point Autmation workshop at CPX 2025, allowing engineers to get hands-on experience on the Check Point management API and the integration with Terraform and Ansible

**Environment information**. The environment includes a DevSecOps workstation (this virtual machine, **Windows Client**) installed with Microsoft Visual Studio Code IDE that remotely access the orchestration server (**orchestrator** virtual machine) to edit the IaC templates and run automation tasks.

The automation tools used in the workshop (terraform and ansible) running on the orchestration server are translating high level orchestration tasks into low-level REST API requests sent to endpoints exposed by (**Check Point Quantum R82 Management** virtual machine).

The result of automation operations will be verified in the Quantum Security Management Web SmartConsole accessed from the browser installed on **Windows Client** (this VM).

## Connect to the environment
1. Open the provided link and go to the tab “**Windows Client**” in in Visual Studio Code IDE. You will be presented with Visual Studio Code IDE already launched.
2. On "**Windows Client**" click on "**Reload Window**" to allow Visual Studio Code to reconnect to the Orchestration Server
<br><img width="469" alt="image" src="https://github.com/user-attachments/assets/b9d6a66c-39bf-4bd9-86e5-e96583f1558b" />

3. Adjust keyboard layout if needed <img width="100" alt="image" src="https://github.com/user-attachments/assets/c6f0d9b1-167b-4306-a21a-0c4be2ffc241" />

4. Follow the instructions in the open **README.md** in Visual Studio Code

## Prepare the environment
1. In this environment we stored the login information in these environmental variables 
   * CHECKPOINT_API_KEY 
   * CHECKPOINT_SERVER

2. Review that the environmental variables contains the necessary values by executing the following command in visual studio code terminal session connected to the orchestration server
```bash
printenv CHECKPOINT_API_KEY
printenv CHECKPOINT_SERVER
```
<br><img width="469" alt="image" src="https://github.com/user-attachments/assets/14d425c0-5427-4930-a2a8-0a1b3c05c4c4" />

3.  Use the Microsoft Edge browser to access management server [Web SmartConsole](https://10.128.0.100/smartconsole) with **"admin/Cpwins1!"** credentials.
<br><img width="200" alt="image" src="https://github.com/user-attachments/assets/fc23f4c3-237a-4a48-9d03-d3d2cd727f39" />
<br>In case the following error message appear: “**Web SmartConsole service is not available**”
<br>This is because Web SmartConsole was updated to a newer version, **just reload the webpage** and accepting the new certificate to proceed.
<br><img width="469" alt="image" src="https://github.com/user-attachments/assets/f31dad74-e60c-48a6-bdfe-b1f0342457a0" />
<br>Review the current policy packages and verify that there are no host objects in the objects pane on the right side of SmartConsole
<br><img width="200" alt="image" src="https://github.com/user-attachments/assets/fc23f4c3-237a-4a48-9d03-d3d2cd727f39" />
<br><img width="569" alt="image" src="https://github.com/user-attachments/assets/140e7778-83e2-41d2-8a66-c3fc0e1d4ba9" />

## Lab 1 - Build simple Check Point policy with IAC using Terraform  

### Review Terraform configuration
1. Review **main.tf** terraform configuration file. As you can see, we have defined two aliases for the provider configuration, allowing us to login to different domains in the management server in one terraform run.
 - The code block `module "admins" {` points to the folder **system-data** containing  the terraform configuration to create an admin
 - The code block `module "policy" {` points to the folder **policy** containing  the terraform configuration to create the Security Policy
 - In the **checkpoint_management_publish** code blocks you can see that it is configured to trigger when there is a configuration change on the files in the folders system-data and policy, as well as forcing it to run on terraform destroy actions.
 - The below command will open the **~/CPX-2025-automation-ws/01-terraform/main.tf** file in Visual Studio code 
```bash
code ~/CPX-2025-automation-ws/01-terraform/main.tf
```

2. Review **admins.tf**, terraform configuration file and review the code block to create an administrator,
<br>The below command will open the file in **~/CPX-2025-automation-ws/01-terraform/system-data/admins.tf** Visual Studio code 
```bash
code ~/CPX-2025-automation-ws/01-terraform/system-data/admins.tf
```

3. Review **hosts.tf**, terraform configuration file and review the code block to add host objects to the security configuration,
<br>The below command will open the file in **~/CPX-2025-automation-ws/01-terraform/policy/hosts.tf** Visual Studio code 
```bash
code ~/CPX-2025-automation-ws/01-terraform/policy/hosts.tf
```

### Deploy the policy
You are now ready to deploy the policy using terraform

1. Change to the 01-terraform folder
```bash
cd ~/CPX-2025-automation-ws/01-terraform
```
2. Run `terraform init` to download the provider and initialize the corresponding modules
3. Run `terraform apply` and look at the plan and the 33 changes that will be made
4. Accept by answering **yes**

5. Run `terraform apply` again and see that there will be no changes made since your security infrastructure matches your configuration
<br>You should see the following:
<br><img width="469" alt="image" src="https://github.com/user-attachments/assets/77e7f39b-6d10-4b34-b235-0902d4ddba48" />

### Review changes applied by Terraform
1. Go to Web SmartConsole **"admin/Cpwins1!"**, review some of the changes applied by terraform.
<br><img width="469" alt="image" src="https://github.com/user-attachments/assets/0e090de5-9a2e-4bd2-ba20-3b7edb6ab2de" />

### Change your Terraform configuration and review the changes
1. Open **hosts.tf**, terraform configuration file in in visual studio code and change the color of the host object **azure_lb_health_check** to **red**.
<br>The below command will open the file in **~/CPX-2025-automation-ws/01-terraform/policy/hosts.tf** Visual Studio code 
```bash
code ~/CPX-2025-automation-ws/01-terraform/policy/hosts.tf
```
2. Save the changes to the file by pressing `ctrl+s`
3. Run `terraform apply`, look at the plan and try to understand what changes terraform will make
4. Accept by answering **yes**
5. Go to Web SmartConsole **"admin/Cpwins1!"**, and see if the color of the host object has changed.

### Destroy a Terraform resource and review the changes
1. Open **hosts.tf**, terraform configuration and remove the code block for the resource "**azurelbhealthcheck**"
<br>The below command will open the file in **~/CPX-2025-automation-ws/01-terraform/policy/hosts.tf** Visual Studio code 
```bash
code ~/CPX-2025-automation-ws/01-terraform/policy/hosts.tf
```
2. Save the changes to the file by pressing `ctrl+s`
3. Run `terraform apply`, look at the plan and try to understand what changes terraform will make
4. Accept by answering **yes**
5. Go to Web SmartConsole **"admin/Cpwins1!"**, and verify that the host object has been removed

**Done**: Go to next lab in 02-ansible folder by executing this command
```bash
cd ~/CPX-2025-automation-ws/02-ansible/
```
## Lab 2 - Build and maintain an enterprise Check Point policy with IAC using Ansible   

### Task 1 - Add latest Check Point management ansible collection
Install the Management collection with this command:
```bash
ansible-galaxy collection install check_point.mgmt
```
If you get an notification that "Nothing to do. All requested collections are already installed" run the install of the collection again using `--force`
```bash
ansible-galaxy collection install check_point.mgmt --force
```
### Task 2 - Add latest Check Point Gaia ansible collection
Install the Gaia collection with this command:
```bash
ansible-galaxy collection install check_point.gaia
```

### Task 3 - Deploy the enterprise policy using Ansible
You are now ready to deploy and maintain an enterprise policy using ansible
1. Review **inventory.yml**, as you can see we are using the environment variables to authenticate.
<br>The below command will open the **~/CPX-2025-automation-ws/02-ansible/inventory.yml** file in Visual Studio code 
```bash
code ~/CPX-2025-automation-ws/02-ansible/inventory.yml
```

2. Deploy an enterprise policy from this playbook **demo-policy-playbook.yml** via ansible using the following command:
```bash
ansible-playbook demo-policy-playbook.yml -i inventory.yml
```

3. In order to save some time, we will while the enterprise policy is being built continue to **Task 4**.

### Task 4 - Create and change your own object using ansible
To save some time we will use another playbook file in order not run through all the tasks again.
1. Open a new terminal in Visual Studio code by clicking on the **+** sign in the lower right corner of VS code.
<br><img width="369" alt="image" src="https://github.com/user-attachments/assets/ec2f7c13-ba42-4ab4-bd8e-9694633518a3" />

2. Go to the 02-ansible folder by executing this command:
```bash
cd ~/CPX-2025-automation-ws/02-ansible/
```

3. Open the file **myobjects/main.yml** and review the code in there
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
>[!NOTE]
> ```auto_publish_session: true``` will publish the changes for this task when it is being executed

4. Save the changes to the file by pressing `ctrl+s`
5. Run the playbook **myobject-playbook.yml**
```bash
ansible-playbook myobject-playbook.yml -i inventory.yml
```
In the terminal window monitor the execution of the playbook. Note the order in which objects in IaC files are deployed.
<br>What do you think will happen if you will interrupt the execution of playbook and re-run it?

6. Go to  Web Smart Console **"admin/Cpwins1!"**, see the changes applied by Ansible.
<br>![image](https://github.com/user-attachments/assets/4bc15524-1d4d-4e21-9ea7-dec2d867483c)

### Task 5 - Test idempotency of your playbook and the modules
1. Re-run the playbook **myobject-playbook.yml**, you will see that the modules are **idempotent**. Since your ansible code (desired state) is equal to the reality (current state). no change is made and ansible responds with ok
```bash
ansible-playbook myobject-playbook.yml -i inventory.yml
```
![image](https://github.com/user-attachments/assets/173dea57-bcab-4ecc-9eb3-188875f48977)

>[!NOTE]
> A request method is considered **idempotent** if the intended effect on the server of multiple identical requests with that method is the same as the effect for a single such request.

### Task 6 - Change your ansible playbook and review the changes
1. Change the color to `color: sea green` for the object in **myobjects/main.yml**
2. Save the changes to the file by pressing `ctrl+s`
3. Re-run the playbook, notice that the status reported for the task is "changed: [R82mgmt]".
```bash
ansible-playbook myobject-playbook.yml -i inventory.yml
```

4. Go to Web Smart Console **"admin/Cpwins1!"**, see the changes applied by Ansible.

### Task 7 - Remove the object by making it absent
1. Set the state of the object in **myobjects/main.yml** to absent
```yaml
state: absent 
```
2. Re-run the playbook myobject-playbook.yml 
```bash
ansible-playbook myobject-playbook.yml -i inventory.yml
```

3. Go to Web Smart Console **"admin/Cpwins1!"**, check what happened with your object.
<br>What does `state: absent` mean?

### Task 8 - Review the enterprise policy that was created using Ansible
1. Use the Browser to go to Web SmartConsole **"admin/Cpwins1!"**, see the changes applied by Ansible. 
<br>You should see new gateways as well as a Branch office and Corporate policy similar to SmartConsole demo mode:
<br><img width="469" alt="image" src="https://github.com/user-attachments/assets/0b417594-5cd5-4244-b17e-05909615f5fa" />

**Done**: If you have some spare time you can go to https://galaxy.ansible.com/ui/namespaces/check_point/, pick an example from the management collection list and try to create that object with Ansible, or make some changes to your terraform configuration to see what happens.

## Resources:
- [sk121360 - Check Point APIs homepage](https://support.checkpoint.com/results/sk/sk121360)
- [Check Point API Reference Guide](https://sc1.checkpoint.com/documents/latest/api_reference/index.html)
- [Check Point AI Copilot](https://support.checkpoint.com/ai)
- [Check Point Management Terraform Provider](https://registry.terraform.io/providers/CheckPointSW/checkpoint/latest/docs)
- [Check Point Ansible collection for the Management Server](https://galaxy.ansible.com/ui/repo/published/check_point/mgmt/)
- [Github - Check Point Software Technologies Ltd.](https://github.com/checkpointsw)
- [Github - Check Point CheckMates Community](https://github.com/checkpointsw-community)
  -  [AnsibleFest2020-Demos](https://github.com/CheckPointSW-Community/AnsibleFest2020-Demos)
  -  [chkp-api-examples](https://github.com/CheckPointSW-Community/chkp-api-examples)
  -  [Ansible_CHKP_labs](https://github.com/CheckPointSW-Community/Ansible_CHKP_labs)
  -  [Terraform_CHKP_labs](https://github.com/CheckPointSW-Community/Terraform_CHKP_labs)
- [CheckMates - API / CLI Discussion](https://community.checkpoint.com/t5/API-CLI-Discussion/bd-p/codehub)
- [CheckMates - Ansible Discussion](https://community.checkpoint.com/t5/Ansible/bd-p/ansible)
- [Check Point Smart-1 Cloud](https://sc1.checkpoint.com/documents/Infinity_Portal/WebAdminGuides/EN/Check-Point-SmartCloud-Admin-Guide/Topics-Smart-1-Cloud/Overview.htm)
- [Github Codespaces](https://github.com/codespaces)
- [VScode](https://code.visualstudio.com/)
