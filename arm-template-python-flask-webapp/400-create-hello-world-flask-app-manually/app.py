from flask import Flask
import datetime
app = Flask(__name__)

@app.route("/")
def home():
    return f"Hello, Flask! Current clock time is: {datetime.datetime.utcnow()}"


