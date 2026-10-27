# Implementation Flow
## Python logic Word Count
Objective: Logic for lambda to have word count function
- `count_words()` function utilizes Python's `split()` tp separate words between whitespaces and returns their count. 

Expected behavior:
- Normal text returns the number of words between whitespaces (including spaces, tabs, newlines)
- Empty text returns 0
- Whitespace only returns 0
- Punctuation remains part of a word and not stripped

## Testing
Objective: Test with expected outcome and other scenarios
- Pytest `test_wordcount.py` and how it will behave along with five scenarios: 
    - counting words - counts words inside the file
    - an empty string - passed, words: 0
    - only whitespace - passed, words: 0
    - Only new lines and tabs - passed, words: 0
    - punctuations - if attached to another word, words: 0 but punctuation alone in itself can be counted as a word

- Pytest `test_handler.py` for handler testing in a local environment
    - mock, an object that stands in for real dependency during test
    - patch, temporary replaces target (`with` makes expressions able to `__enter__()` and `__exit__()` methods)
    - BytesIO for returning bytes to satisfy process in handler
    - `handler.s3` is better for patch than `s3` alone since `handler.s3` used handler name unlike `s3` that is direct to the original object.
## Python Project Set-up
Main Objective is to keep a reproducible application.

Tools:
- Python 3.12
- uv for Python Project Management
- pytest for testing
- Development dependencies are declared separately from application dependencies in pyproject.toml

## Continuous Integration
Automatically run tests when changes are pushed or pull requests are opened.

GitHub Actions runs the Python test in a dedicated environment.

The workflow uses `uv` dependencies and executes commands in the same manner.

## AWS Lambda Handler
Objective: To apply Lambda Function Logic and connect with AWS service
1. Extract bucket name and object from event trigger.
2. Inspects if object is a `.txt` file, case-insensitively, skips if not.
3. Retrives object via `s3.get_object()`
4. Decodes the stream of bytes into `utf-8`.
5. Counts the number of words using `count_words()` function
6. Publish to sns a message for the email subscription

## Lambda Package
Objective: Compile Python Package for Lambda 
Deployment.zip contains:
- `textfile_wordcount_processor/handler.py`
- `textfile_wordcount_processor/wordcount.py`
- `textfile_wordcount_processor/__init__.py`

The package directory must be at the expected level inside the ZIP so that Lambda can import the configured handler.

The ZIP is currently built at:
`build/lambda_package/deployment.zip`
## Infrastructure as Code
Objective: Define AWS Infrastructure using Terraform

- Amazon S3 bucket
- AWS Lambda function
- Lambda execution IAM role and permissions
- Amazon SNS topic
- CloudWatch log group with a 14-day retention period
- S3-to-Lambda invocation permission
- S3 object-created notification
- SNS email subscription

## Integration and Deployment Testing
Status: Pending AWS deployment.

Planned verification:

1. Deploy the infrastructure.
2. Confirm the SNS email subscription.
3. Upload a supported .txt file.
4. Verify that the Lambda function is invoked.
5. Check the word count in CloudWatch Logs.
6. Confirm that the SNS notification arrives by email.
7. Test unsupported file extensions.
8. Check the results and clean up resources when finished.