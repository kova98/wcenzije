from os import listdir
from os.path import isfile, join
import json
import requests

path = './posts'
url = 'http://localhost:5085/api/review'

files = [f for f in listdir(path) if isfile(join(path, f))]

for file in files:
    file_path = join(path, file)
    with open(file_path, encoding="utf-8") as file_json:
        file_data = json.load(file_json)
        print(f'Uploading post {file}')
        requests.post(url, json=file_data)