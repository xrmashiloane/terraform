# Weather Client

A lightweight weather API call application written in Python that calls external API on a schedule to retrieve current weather conditions for a provided location.

Project demonstrates using Terraform to provision AWS resourses in with state saved in Terraform Cloud and code stored in Git for source control. Code provides end to end CI/CD pipeline via Github Actions and Terraform Cloud.

GitHub actions to provide Continuos Integration.
Terraform Cloud to provide Continuous Delivery.

## Architecture Diagram

![Architecture Diagram](ArchitectureDiagram.png)

## Environment Setup

> [!IMPORTANT]  
> To run this project, you must add the following environment variables to your `.tfvars` file. 

`api_access_key_value`
`aws_region`



> [!WARNING]  
> Always have a .gitignore file to prevent inadvent leakage of sensetive information. 


## Prerequisites

> [!IMPORTANT]  
> To eliminate need for long loved credentials you can use Role Based Access Control for this project. This will set up temporary credentials assigned to a specified role linked to Terraform Cloud.
>This ensures that all actions taken by Terraform Cloud are auditable as well as minimising the blast radius as each run generates temporary token for provisioning steps.
>Initial setup can be found in `aws_openid_config/trust`


Setup Terraform Cloud with VCS/Git workflow: https://developer.hashicorp.com/terraform/tutorials/cloud-get-started/cloud-sign-up 

Sign up for free weather API account: https://weatherstack.com/signup

Rename terraform.tf.example to terraform.tf 



## Deployment


Deployment must be done in order below to ensure all components work as expected. 

Step 1 Configure Terraform Cloud.
Update files found in ./terraform_cloud_config 

Run below commands to configure

```bash
  terraform init
```

```bash
  terraform plan
```

```bash
  terraform apply
```

Step 2 Create required repository 
Update files found in ./github_actions_config 

Run below commands to configure

```bash
  terraform init
```

```bash
  terraform plan
```

```bash
  terraform apply
```

Step 3 Create AWS Role

Update files found in ./aws_openid_config/trust 

Run below commands to configure

```bash
  terraform init
```

```bash
  terraform plan
```

```bash
  terraform apply
```

Step 4 Link project to GitHub by following steps here: https://developer.hashicorp.com/terraform/tutorials/cloud-get-started/cloud-vcs-change


Remember to delete saved long lasting credentials from local environment for improved security.



> [!IMPORTANT]  
> Set Terraform Cloud to `aws_infra` in workspace setting to ensure correct files are loaded for plans.
 >More information here: https://developer.hashicorp.com/terraform/cloud-docs/workspaces/settings#terraform-working-directory


## Environment Clean up

Environment clean up. 

1. Queue a Destroy Plan via Terraform Cloud. Instructions here: https://developer.hashicorp.com/terraform/tutorials/cloud-get-started/cloud-destroy

2. Run destroy on each config folder in reverse to clean up. Destroy AWS Role --> Destroy Github Repo --> Destroy Terraform Cloud config

```bash
  terraform destroy
```


## Tech Stack

AWS Services 
**Client:** Python

**Server:** Serverless Compute

**Lambda**
**SQQ**
**SNS**
**IAM**
**SSM Parameter Store**
**DynamoDB**

Enablement Services 

**Terraform Cloud**
**API Endpoint** https://weatherstack.com/quickstart
**GitHub**
**GitHub Actions**
**OpenID Connect**

## Authors

- [@xrmashiloane](https://www.github.com/xrmashiloane)


## License

This library is licensed under the MIT-0 License. See the [LICENSE](LICENSE) file.