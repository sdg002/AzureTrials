"""
This is a hello world Web application
"""
import datetime as dt
from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello():
    now=dt.datetime.now()
    return f"Hello world , current date is {now}"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)