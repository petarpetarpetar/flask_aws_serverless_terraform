import logging
import os
import boto3

FILENAME = '../../cursor_tracks.txt'  # Global variable for filename

def setup_logging(log_level=logging.INFO):
    """
    Set up logging for the application.
    """
    logging.basicConfig(level=log_level)
    logger = logging.getLogger(__name__)
    return logger

def handle_api_error(e):
    """
    Handle errors from API calls.
    """
    logger = setup_logging()
    logger.error(f"API Error: {e}")

def format_video_data(video_data):
    """
    Format video data for uploading.
    """
    # This is a placeholder function. You would need to implement the actual formatting based on your requirements.
    formatted_data = video_data
    return formatted_data

def update_last_cursor(user_id, cursor):
    data = {}
    if os.path.exists(FILENAME):
        with open(FILENAME, 'r') as f:
            for line in f:
                k, v = line.strip().split(',')
                data[k] = v

    data[user_id] = cursor

    with open(FILENAME, 'w') as f:
        for k, v in data.items():
            f.write(f'{k},{v}\n')

def read_last_cursor(user_id):
    with open(FILENAME, 'r') as f:
        for line in f:
            k, v = line.strip().split(',')
            if k == user_id:
                return v
    return None



def send_message_to_sqs(queue_url, message_body):
    """
    Send a message to the specified SQS queue.
    """
    # Create a session using boto3
    session = boto3.Session()
    sqs = session.client('sqs')

    # Send the message
    response = sqs.send_message(
        QueueUrl=queue_url,
        MessageBody=message_body
    )

    return response

def receive_message_from_sqs(queue_url):
    """
    Receive a message from the specified SQS queue.
    """
    # Create a session using boto3
    session = boto3.Session()
    sqs = session.client('sqs')

    # Receive the message
    response = sqs.receive_message(
        QueueUrl=queue_url,
        MaxNumberOfMessages=1,
        WaitTimeSeconds=0
    )

    # If a message was received, return it
    if 'Messages' in response:
        return response['Messages'][0]

    return None