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
