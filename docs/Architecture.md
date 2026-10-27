# Architecture
![Architecture diagram](/docs/Architecture.png)

1. User uploads the `.txt` file
2. S3 will trigger an event
    - IAM policy allows s3 to activate lambda function
3. Lambda receives the event and requests contents from s3 via boto3
    - IAM policy allows lambda to read the s3 bucket
    - IAM policy lambda action is logged in CloudWatch
4. Lambda process the contents and print out the filename and its word count.
5. Sumbits the information to SNS.
    - IAM policy allows to publish in SNS
6. SNS sends out the info to a subscribed email to the topic.