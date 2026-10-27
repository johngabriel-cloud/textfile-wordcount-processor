# Terraform Deployment
## Protect Local Configuration
- Add these to `.gitignore`
    ```
    terraform/terraform.tfvars
    terraform/*.auto.tfvars
    terraform/terraform.tfstate
    terraform/terraform.tfstate.*
    terraform/.terraform/
    ```
## tfvars
- if Python has `.env`, Terraform has `.tfvars`
- Create terraform/terraform.tfvars:
    ```
    bucket_name: "globally-unique-name"
    notification_email: "your-email-for@testing"
    ```
## terraform plan
- From project root, `terraform -chdir=terraform plan`
- Review changes before `terraform apply`:
    - The intended S3 bucket and SNS topic will be created.
    - The Lambda function points to the expected deployment ZIP.
    - IAM permissions are limited to the required resources and actions.
    - The S3 event notification references the correct Lambda function.
    - The SNS subscription uses the intended email address.
    - No unexpected resource replacements or deletions are proposed.