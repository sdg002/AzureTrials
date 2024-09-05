"""
Connects to the local web app as a demonstration of internal HTTP communications
"""

import os
import requests

if __name__ == "__main__":
    print("Begin")
    WEB_URL="MYWEBAPP"
    url=os.environ.get(WEB_URL, None)
    print(f"Going to read the environment variable: {WEB_URL}")
    if url is None:
        raise ValueError(f"The environment variable {WEB_URL} was not found")
    print(f"Got the URL {url}")

    response=requests.get(url=url)
    if not response.ok:
        print(f"HTTP failer. {response.status_code=}")
    
    print("Success")
    print("Response is:")
    print(response.text)
    print("--------------------")
    print("Done")
