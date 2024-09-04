"""
Long running job
"""
from time import sleep
import datetime
import os
APP_VERSION=1.6

COUNT=10

def display_variables()->str:
    keys=list(os.environ.keys())
    keys.sort()
    print("----------------------")
    result=""
    print(f"Version:{APP_VERSION}<br/>")
    print("----------------<br/>")
    for key in keys:
        line=(f"{key}={os.environ[key]}<br/>")
        print(line)
    print("----------------------")
    return result

if __name__ == "__main__":
    print("Begin")
    display_variables()
    for idx in range(COUNT):
        now=datetime.datetime.now()
        print(f"This is attempt number {idx} at {now}\n")
        print("--------------------------\n")
        sleep(0.5)
    print("All done")