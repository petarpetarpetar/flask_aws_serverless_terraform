import os
from dotenv import load_dotenv
import requests

from ..utils.helpers import read_value, store_key_value
load_dotenv()  # take environment variables from .env.

def get_user_posts_info(user_id, count=30):
    url = os.getenv("VIDEOS_IDS_API_URL")
    querystring = {"user_id":user_id,"count":count,"cursor":"0"}
    headers = { 
        "X-RapidAPI-Key": os.getenv("VIDEOS_IDS_API_KEY"), 
        "X-RapidAPI-Host": os.getenv("VIDEOS_IDS_API_HOST") 
    }
    response = requests.get(url, headers=headers, params=querystring)

    return response.json()

def extract_video_ids(response):
    video_ids = []
    for video in response.json():
        video_id = video.get('video_id')
        if video_id:
            video_ids.append(video_id)
    return video_ids

def get_user_videos(user_id):
    last_cursor_stop = read_value(user_id)
    if not user_id:
        store_key_value(user_id, last_cursor_stop)
    user_posts_info = get_user_posts_info(user_id)
    video_ids = extract_video_ids(user_posts_info)
    print(video_ids)
    return video_ids