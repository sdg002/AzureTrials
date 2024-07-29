import datetime as dt
import time

def do_some_long_running_operation():
    """
    Emulate a long running job by looping for ever and keep writing to the console
    """
    while True:
        print(f"Time now is {dt.datetime.now()}")        
        time.sleep(0.5)    


if __name__ == "__main__":
    do_some_long_running_operation()
