"""
This is a hello world Web application
"""
import datetime as dt
from flask import Flask
import os

app = Flask(__name__)
APP_VERSION=1.6

@app.route('/')
def hello():
    now=dt.datetime.now()
    vars=display_variables()
    return f"{vars}\n--------\nHello world , current date is {now}"

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