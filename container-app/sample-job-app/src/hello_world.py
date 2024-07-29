import datetime as dt
import time

def do_some_long_running_operation():
    """
    Emulate a long running job by looping for ever and keep writing to the console
    """
    counter=0
    while True:
        counter+=1
        print(f"Time now is {dt.datetime.now()}, {counter=}")
        time.sleep(0.5)


if __name__ == "__main__":
    do_some_long_running_operation()
