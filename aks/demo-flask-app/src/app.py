"""
This is a hello world Web application
"""
import os
import datetime as dt
from flask import Flask
from pymemcache.client import base

app = Flask(__name__)
APP_VERSION=1.6

@app.route('/')
def hello():
    """
    This is very simple implementation of a landing page
    """
    now=dt.datetime.now()
    vars=display_variables()
    return f"{vars}\n--------\nHello world , current date is {now}"

@app.route('/memcached')
def memcached_demo():
    MEMCACHED_ENV="MEMCACHED_SERVER"
    MEMCACHED_KEY="mykey001"
    print("Begin")
    print(f"Going to get the URL of the memcached server from the environment variable {MEMCACHED_ENV}")
    memcached_server=os.environ.get(MEMCACHED_ENV)
    if not memcached_server:
        return f"The environment variable '{MEMCACHED_ENV}' was empty"
    client=base.Client((memcached_server,"11211"))
    print(f"Connected to the memcached server {memcached_server}")
    payload=client.get(MEMCACHED_KEY)
    print(f"Got the payload {payload} from memcached server")
    return payload

def display_variables()->str:
    keys=list(os.environ.keys())
    keys.sort()
    print("----------------------")
    result=""
    result+=f"Version:{APP_VERSION}<br/>"
    result+="----------------<br/>"
    for key in keys:
        line=(f"{key}={os.environ[key]}<br/>")
        result+=line
    print("----------------------")
    return result

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)