import boto3
from textfile_wordcount_processor.wordcount import count_words
import os

s3 = boto3.client('s3')
sns = boto3.client('sns')


def lambda_handler(event, context):
    bucket_name = event["Records"][0]["s3"]["bucket"]["name"]
    object_key = event["Records"][0]["s3"]["object"]["key"]
    response = s3.get_object(
        Bucket=bucket_name,
        Key=object_key
    )
    file_content = response['Body'].read().decode('utf-8')
    total_count = count_words(file_content)

    sns.publish(
        TopicArn=os.environ['SNS_TOPIC_ARN'],
        Message=f"Total word count for {object_key} in bucket {bucket_name}: {total_count}"
    )