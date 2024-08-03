import datetime as dt
import time
import os
import sys
import logging

def display_environment_variables()->None:
    """
    Display environment variables
    """
    print(*os.environ.items(), sep="\n")
    print("-------------------")
    sys.stdout.flush()

def do_some_long_running_operation()->None:
    """
    Emulate a long running job by looping for ever and keep writing to the console
    """
    counter=0
    while True:
        counter+=1
        logging.info(f"Time now is {dt.datetime.now()}, {counter=}")
        time.sleep(0.5)


if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO)
    display_environment_variables()
    do_some_long_running_operation()
