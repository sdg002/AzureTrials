"""
A simple Python script that sets a key-value in memcached server
"""
import os
import datetime as dt
from pymemcache.client import base

if __name__ == "__main__":
    MEMCACHED_ENV="MEMCACHED_SERVER"
    MEMCACHED_KEY="mykey001"

    print("Begin")
    print(f"Going to get the URL of the memcached server from the environment variable {MEMCACHED_ENV}")
    memcached_server=os.environ.get(MEMCACHED_ENV)
    if not memcached_server:
        raise ValueError(f"The environment variable '{MEMCACHED_ENV}' was empty")

    print(f"Going to connect to memcached server at: {memcached_server}")

    client=base.Client((memcached_server,"11211"))
    print(f"Connected to the memcached server {memcached_server}")
    message=f"This a sample payload {dt.datetime.now()}"
    print(f"Going to set the payload {message} into the key: {MEMCACHED_KEY}")
    client.set(MEMCACHED_KEY, message)
    print("All done")
