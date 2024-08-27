import argparse
import json
import os

import requests
from dotenv import load_dotenv
from googleapiclient.discovery import build
from googleapiclient.errors import HttpError
from tqdm import tqdm
from youtube_transcript_api import YouTubeTranscriptApi

load_dotenv()
api_key = os.getenv("YTB_API_KEY")
youtube = build("youtube", "v3", developerKey=api_key)


def get_channel_id(channel_name):
    """
    Retrieves the id of a youtube channel from its channel name.

    Args:
      channel_name: Name of the youtube channel which is not the full name of channel but the name after the '@'
                    the channel link.

    Returns:
      The id of of the given channel.
    """
    url = "https://www.youtube.com/@" + channel_name
    r = requests.get(url)
    # Retrieve the whole page source
    text = r.text
    # Split the text to get only the section containing the channel id
    id = text.split("youtube.com/channel/")[1].split('">')[0]
    return id


def fetch_video_ids(channel_name):
    """
    Fetches the video IDs of the videos in the uploads playlist of a channel.
    Args:
      channel_name: The name of the channel.
    Returns:
      A list of {video ID, video url, title, description}.
    """
    # Make a request to youtube api
    base_url = "https://www.googleapis.com/youtube/v3/channels"
    channel_id = get_channel_id(channel_name)
    params = {"part": "contentDetails", "id": channel_id, "key": api_key}
    try:
        response = requests.get(base_url, params=params)
        response = json.loads(response.content)
    except HttpError as e:
        print(f"An HTTP error occurred: {e}")
        return []

    if "items" not in response or not response["items"]:
        raise Exception(f"No playlist found for {channel_name}")

    # Retrieve the uploads playlist ID for the given channel
    playlist_id = response["items"][0]["contentDetails"]["relatedPlaylists"]["uploads"]

    # Retrieve all videos from uploads playlist
    videos = []
    next_page_token = None

    while True:
        playlist_items_response = (
            youtube.playlistItems()
            .list(
                part="snippet",
                playlistId=playlist_id,
                maxResults=50,
                pageToken=next_page_token,
            )
            .execute()
        )

        videos += playlist_items_response["items"]

        next_page_token = playlist_items_response.get("nextPageToken")

        if not next_page_token:
            break

    # Extract video details
    video_details = []

    for video in videos:
        video_id = video["snippet"]["resourceId"]["videoId"]
        video_url = f"https://www.youtube.com/watch?v={video_id}"
        video_title = video["snippet"]["title"]
        video_description = video["snippet"]["description"]
        video_details.append({"ID": video_id, "URL": video_url, "Title": video_title, "Description": video_description})

    return video_details


def fetch_transcript(video_id):
    """
    Fetches the transcript of a video.
    Args:
      video_id: The ID of the video.
    Returns:
        The transcript as a string.
    """
    try:
        transcript = YouTubeTranscriptApi.get_transcript(video_id, languages=["en"])
        transcript_text = "\n".join([line["text"] for line in transcript])
    except Exception as e:
        print(f"An error occurred: {e}")
        return None
    return transcript_text


if __name__ == "__main__":
    parser = argparse.ArgumentParser()

    parser.add_argument("--channel_name", help="The name of the channel.", type=str)
    parser.add_argument(
        "--results_dir",
        help="The directory to save the transcripts.",
        type=str,
        default="transcripts",
    )
    parser.add_argument(
        "--max_videos",
        help="The max number of transcripts.",
        type=int,
        default=None,
    )

    args = parser.parse_args()
    max_videos = args.max_videos
    channel_name = args.channel_name
    results_dir = args.results_dir

    TRANSCRIPTS_DIR = os.path.join(os.getcwd(), results_dir)
    os.makedirs(TRANSCRIPTS_DIR, exist_ok=True)

    print(f"Fetching video IDs for {channel_name}...")
    videos = fetch_video_ids(channel_name)
    if max_videos:
        videos = videos[:max_videos]

    print(f"Fetching transcripts for {channel_name}...")
    for i, video in enumerate(tqdm(videos)):
        transcript_text = fetch_transcript(video["ID"])
        if transcript_text:
            json_file = os.path.join(TRANSCRIPTS_DIR, f"{channel_name}_{i}.json")
            with open(json_file, "w", encoding="utf-8", newline="\n") as file:
                json.dump(
                    {
                        "channel_name": channel_name,
                        "video_url": video["URL"],
                        "video_title": video["Title"],
                        # "video_description": video["Description"],
                        "transcript": transcript_text,
                    },
                    file,
                    ensure_ascii=False,
                    indent=4,
                )

    print(f"Saved transcripts for {channel_name}.")
