# Weather Client

A lightweight weather API call application written in Python that calls external API on a schedule to retrieve current weather conditions for a provided location.

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

Setup Terraform Cloud with VCS/Git workflow: https://developer.hashicorp.com/terraform/tutorials/cloud-get-started/cloud-sign-up 

Sign up for free weather API account: https://weatherstack.com/signup

Rename terraform.tf.example to terraform.tf 

Replace values enclosed with <{ }> with own values



## Deployment



First create role with access to provision resources in your AWS accrount using terraform files in path {PROJECT_DIR}/aws_openid/trust set variables accordingly.

Once variables are setup run below to create role for Terraform for use with OpenID for temporary, role based authentication to AWS this conforms to AWS best practice. 

Remember to delete saved long lasting credentials from local environment for improved security.



Each folder has Terraform files each peforming a specific task. 

```bash
  terraform init
```

```bash
  terraform plan
```

```bash
  terraform apply
```

This is only required once if VCS/Git is set up for your Terraform Cloud account. Plans will then run from cloud backend on code check in. 

> [!IMPORTANT]  
> Set Terraform Cloud to `aws_infra` in workspace setting to ensure correct files are loaded for plans.

 More information here: https://developer.hashicorp.com/terraform/cloud-docs/workspaces/settings#terraform-working-directory


## Tech Stack

**Client:** Python

**Server:** Serverless Compute


## Authors

- [@xrmashiloane](https://www.github.com/xrmashiloane)


## License

This library is licensed under the MIT-0 License. See the [LICENSE](LICENSE) file.