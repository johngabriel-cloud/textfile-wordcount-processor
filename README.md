# Serverless Word Count File Processor
## Overview 
The application will read an uploaded `.txt` file in S3, the S3 event triggers a Lambda process and produces an output that will be pusblished to SNS and will be printed to a subscribed email, indicating the filename and word count.
## Architecture
![Architecture diagram](/docs/Architecture.png)
## Technologies
Python | AWS S3 | AWS SDK for Python (Boto3) | AWS Lambda | Amazon SNS | Terraform | pytest | GitHub Actions
## Prerequisites
1. install `terraform`
2. AWS account
## Local Development
- This installation is for python development and testing environment.
- project uses `uv` as its project manager : `python -m pip install uv`
    - `uv sync` to install dependencies
- initiate `uv run pytest -v` to run tests
## Deployment
- From project root,
    - create a `.tfvars` file that contains input needed for the `variable` block in `main.tf`
        - `bucket_name = `
        - `notificaiton_email =`
    - `terraform -chdir=terraform fmt`
    - `terraform -chdir=terraform validate`
    - `terraform -chdir=terraform plan`
    - `terraform -chdir=terraform apply`
    - accept the subscription for the email registered to sns topic
    - go to AWS console to test and upload the file
    - verify the output of the email received
## Documentation
- [Architecture](/docs/Architecture.md)
- [Implementation Flow](/docs/Implementation_Flow.md)
- [Terraform Deployment](/docs/Terraform_Deployment.md)
- [Troubleshooting](/docs/Troubleshooting.md)
- [Lessons Learned](/docs/Lessons_Learned.md)

## Limitations and Future Improvements
### Limitations:
| Decision                                                          | Reason                                                                    |
| ----------------------------------------------------------------- | ------------------------------------------------------------------------- |
| Python word-counting logic is separate from the Lambda handler    | Makes the core function easier to test and reuse                          |
| pytest runs locally with mocked AWS calls                         | Avoids AWS charges during unit testing                                    |
| Terraform manages the infrastructure                              | Makes resource configuration repeatable and reviewable                    |
| Lambda receives the SNS topic ARN through an environment variable | Separates application code from environment-specific resource identifiers |
| Unsupported extensions are skipped                                | Avoids processing files outside the intended scope  

### Future Improvements: 
- S3 object keys containing spaces or special characters may need URL decoding.
- better file structure for terraform files
- direct link to file upload instead of using AWS console and upload to s3
- stricter implementation of word count logic
- raise error for unsupported extensions