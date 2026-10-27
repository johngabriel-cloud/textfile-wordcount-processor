# Lessons learned
### Python
- `wordcount.py`
    - The syntax `if __name__ == "__main__":` prevents the code inside of the block to run when the file is imported. Which allows `wordcount.py` defined in a module to be imported, making the function reusable.
- `src/` stores the core codebase of the Python applicaiton. It separates application code from project files such as tests and configuration.
- `textfile_wordcount_processor/` is the actual python package. Contains modules that the application and other python code can import.
### pytest
- Pytest is a development dependency, not an application dependency. User must check pyproject.toml/uv.lock
    - development dependencies are tools you need to test, develop and verify the app.
        - To install correctly, `uv add --dev pytest` to add pytest as development dependency (linters, formatters, type checkers)
        - To revert/transfer `uv remove pytest` then add as dev dependency.
    - application dependencies are tools the app needs to run.

- Pytest doesn't guarantee everything works in CI
    - There's three things:
        1. Tests work
        2. Project can be installed and imported correctly.
        3. Project can be reproduced.
        - pytest solves tests and behaviors that they can cover, github actions can expose easily the missing dependencies, files, incorrect imports, or environment.
- pytest is a development tool and should be in development dependency group instead of being a part of the runtime dependency group. Pytest must be under `[dependency-groups]` in `pyproject.toml`
- discovered `with` command, opens a state and closes immediately after the code has passed. Useful in testing the handler

### Lambda Handler
- `lambda_handler(event, context)`
    - `event` is the s3 event trigger notif, thats why we can see s3 bucket (name) and uploaded object (key) in that dictionary.
- Event type `PUT` is the upload method if from AWS CLI, Console, AWS SDK.  
- separate `wordcount.py` to `handler.py` to keep the handler separate from the logic.
- boto3 is the AWS SDK for Python, SDK is the language that allows users to interact with AWS services from their application code.
- if not directly communicated through HTTP (upload via AWS CLI, AWS Console, SDK) event type is considered as `PUT` rather than `POST`
### Terraform
- Permissions needed:
    - Lambda (3)
        - Read S3
        - Publish Event
        - allow s3 to make lambda function activate
    - S3
        - After event trigger, call upon lambda function
- Terraform's ability to infer dependencies implicitly
    - s3 notif -> allow s3 lambda permission -> lambda function
        - needed to explicitly tell terraform that the s3 trigger activates the lambda function and also depends on allow s3 in lambda permission
        - if not, AWS may reject the config given that there is not lambda permission allow s3.
        - Solution: `depends_on` establish order, lambda permission allow s3 will be first created resource.
- Used Inline Policy (`aws_iam_role_policy`) instead of Managed policy (`aws_iam_policy`) for custom user policy instead of AWS managed policies
- `source_code_hash = filebase64sha256(...zip)` detects zip file has been changed.
- Can connect .env variables from python to Terraform `SNS_TOPIC_ARN`
