import json
import lzma
from os import listdir
from os.path import isfile, join
import re
from os import path
import time
from imgur_python import Imgur

path = '.'

def main():
    folders = [f for f in listdir(path) if not isfile(join(path, f))]

    # Remove the "wcenzije" folder containing profile info
    folders.sort(reverse=True)
    folders.pop()

    id = input('Imgur Client ID:')
    secret = input('Imgur Client Secret:')

    posts_path = join(path, "posts")

    current = 0

    for folder in folders:
        current = current + 1
        print(f'Extracting folder {current} of {folders.count}')

        folder_path = join(path, folder)  
        post_info = extract_post_info(folder_path)

        content = extract_content(post_info)
        rating = extract_rating(content)
        like_count = extract_like_count(post_info)
        name, lat, lng = extract_location(post_info)
        image_urls = upload_images(folder_path, id, secret)

        post = {
            "name": name,
            "content": content,
            "rating": rating,
            "like_count": like_count,
            "location": f"{lat},{lng}",
            "imageUrls": image_urls
        }

        post_path = join(posts_path, f"{folder}.json")

        with open(post_path, "w") as outfile:
            json.dump(post, outfile) 
    

def extract_content(post_info):
    return post_info['node']['edge_media_to_caption']['edges'][0]['node']['text']

def extract_location(post_info):
    try:
        location = post_info['node']['iphone_struct']['location']
        lat = location['lat']
        lng = location['lng']
        name = location['short_name']

        return (name, lat, lng)
    except:
        return ('location unavailable', '', '')

def extract_like_count(post_info):
    return post_info['node']['edge_media_preview_like']['count']

def extract_rating(content):
    full_rating = re.search('([0-9]+\/[0-9]+)', content).group()
    return full_rating.split('/')[0]

def extract_post_info(folder_path):
    files = [f for f in listdir(folder_path) if isfile(join(folder_path, f))]
    post_info_json_name = [f for f in files if f.endswith('.json.xz')][0]
    post_info_json_path = join(folder_path, post_info_json_name)

    with lzma.open(post_info_json_path) as f:
        json_bytes = f.read()
        stri = json_bytes.decode('utf-8')
        return json.loads(stri)

def upload_images(folder_path, id, secret):
    print(f'Uploading images from {folder_path}...')

    files = [f for f in listdir(folder_path) if isfile(join(folder_path, f))]
    image_paths = [join(folder_path, f) for f in files if f.endswith('.jpg')]
    imgur_client = Imgur({'client_id': id, 'access_token': secret})
    image_urls = []

    for path in image_paths:
        response = imgur_client.image_upload(path, 'Untitled', 'Wcenzije test')

        while response['status'] == 429:
            rate_limit_header = response['response'].headers['X-Ratelimit-Userreset']
            cooldown = int(rate_limit_header) + 5
            print(f'Rate limited. Waiting for {cooldown} seconds.')
            time.sleep(cooldown)
            response = imgur_client.image_upload(path, 'Untitled', 'Wcenzije test')

        image_url = response['response']['data']['link']
        image_urls.append(image_url)

    print('Sleeping for 5 seconds...')
    time.sleep(5)

    return image_urls

main()