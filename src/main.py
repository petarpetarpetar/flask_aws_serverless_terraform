from api.fetch_videos import fetch_videos
from api.upload_videos import upload_videos

def main():

    videos = fetch_videos()
    upload_videos(videos)


if __name__ == "__main__":
    main()