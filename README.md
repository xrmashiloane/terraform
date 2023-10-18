# Weather Client

A lightweight weather API call application written in Python that calls external API to retrieve current weather conditions for a provided location.

## Architecture Diagram

![ArchitectureDiagram](https://github.com/xrmashiloane/terraform/assets/17061164/7e002ec0-94b3-4628-9fe6-19a55910cf75)


## Environment Variables

To run this project, you will need to add the following environment variables to your .env file

`api_access_key_value`
`aws_region`

## Deployment

First create role with access to provision resources in your AWS accrount using terraform files in path ./aws/trust set variables accordingly.

Once variables are setup run below to create role for Terraform for use with OpenID for temporary, role based authentication to AWS

```bash
  terraform init
```

```bash
  terraform plan
```

```bash
  terraform apply
```

## Tech Stack

**Client:** Python

**Server:** Serverless Compute

## Lessons Learned

What did you learn while building this project? What challenges did you face and how did you overcome them?


## Authors

- [@xrmashiloane](https://www.github.com/xrmashiloane)


## License

This library is licensed under the MIT-0 License. See the [LICENSE](LICENSE) file.