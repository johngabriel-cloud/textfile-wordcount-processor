import pytest
import os
os.environ["AWS_DEFAULT_REGION"] = "us-east-1"

from textfile_wordcount_processor.handler import lambda_handler
import textfile_wordcount_processor.handler as handler
from unittest.mock import patch
from io import BytesIO


def test_lambda_handler():
    event = {
    "Records": [
            {
            "s3": {
                "bucket": {"name": "test-bucket"},
                "object": {"key": "sample.txt"}
                }
            }
        ]
    }

    total_count = 7 #Predicts the number of words
    with patch.dict(os.environ, {"SNS_TOPIC_ARN": "test-topic-arn"}): #dummy Topic ARN to use for patch

        with patch('textfile_wordcount_processor.handler.s3') as mock_s3: #temporary replace s3 object
            fake_response = BytesIO(b"Hello world! This is a test file.")
            mock_s3.get_object.return_value = {'Body': fake_response}
            
            with patch('textfile_wordcount_processor.handler.sns') as mock_sns: #temporary replace sns object
                lambda_handler(event, None) #catches both patch s3 and sns as function
                mock_s3.get_object.assert_called_once_with(
                                Bucket='test-bucket', 
                                Key='sample.txt'
                                )
                mock_sns.publish.assert_called_once_with(
                    TopicArn=handler.os.environ['SNS_TOPIC_ARN'],
                    Message=f"Total word count for sample.txt in bucket test-bucket: {total_count}"
                )