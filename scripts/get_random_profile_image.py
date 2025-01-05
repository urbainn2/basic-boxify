import requests


def get_random_profile_image():
    response = requests.get('https://randomuser.me/api/')
    if response.ok:
        data = response.json()
        profile_image_url = data['results'][0]['picture']['large']
        return profile_image_url
    else:
        response.raise_for_status()
