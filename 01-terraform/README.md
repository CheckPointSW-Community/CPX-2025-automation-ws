## Lab 1 - Build simple Check Point policy with IAC using Terraform  

### Prepare the enviroment
1. In this enviroment we strored the login information in these enviromental variables 
   * CHECKPOINT_API_KEY 
   * CHECKPOINT_SERVER

2. Review that the enviromental variables contains the neccessaru values by executing the following command in visual studio code teminal session connected to the orchestration server
```bash
   echo $CHECKPOINT_API_KEY
   echo $CHECKPOINT_SERVER
```

### Deploy the policy
You are now ready to deploy the policy using terraform
```bash
# enter this folder
cd ~/CPX-2025-automation-ws/01-terraform
#
terraform init
terraform apply
# look at the plan and the changes that will be made
# Accept by answerign yes

```
### Review changes applied by Terraform
Go to the Web based Smart Console and see the changes applied by terraform.

**Done**: Go to next lab in 02-ansible folder by executing this command
```bash
cd ~/CPX-2025-automation-ws/02-ansible/
```
