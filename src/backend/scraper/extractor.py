import json
import lzma
from os import listdir
from os.path import isfile, join
import re

path = '.'

def main():
    folders = [f for f in listdir(path) if not isfile(join(path, f))]

    # Remove the "wcenzije" folder containing profile info
    folders.sort(reverse=True)
    folders.pop()

    for folder in folders:
        folder_path = join(path, folder)
                
        post_info = extract_post_info(folder_path)
        content = extract_content(post_info)
        rating = extract_rating(content)
        like_count = extract_like_count(post_info)
        name, lat, lng = extract_location(post_info)
        image_urls = upload_images(folder_path)

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

def upload_images(folder_path):
    files = [f for f in listdir(folder_path) if isfile(join(folder_path, f))]
    images = [join(folder_path, f) for f in files if f.endswith('.jpg')]
    
    # TODO: actually upload images and return the urls
    return images


main()