## Lab 1 - Build simple Check Point policy with IAC using Terraform  

### Task 1 - Review Terraform configuration
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

### Task 2 - Deploy the policy
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

### Task 3 - Review changes applied by Terraform
1. Go to Web SmartConsole **"admin/Cpwins1!"**, review some of the changes applied by terraform.
<br><img width="469" alt="image" src="https://github.com/user-attachments/assets/0e090de5-9a2e-4bd2-ba20-3b7edb6ab2de" />

### Task 4 - Change your Terraform configuration and review the changes
1. Open **hosts.tf**, terraform configuration file in in visual studio code and change the color of the host object **azure_lb_health_check** to **red**.
<br>The below command will open the file in **~/CPX-2025-automation-ws/01-terraform/policy/hosts.tf** Visual Studio code 
```bash
code ~/CPX-2025-automation-ws/01-terraform/policy/hosts.tf
```
2. Save the changes to the file by pressing `ctrl+s`
3. Run `terraform apply`, look at the plan and try to understand what changes terraform will make
4. Accept by answering **yes**
5. Go to Web SmartConsole **"admin/Cpwins1!"**, and see if the color of the host object has changed.

### Task 5 - Destroy a Terraform resource and review the changes
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
