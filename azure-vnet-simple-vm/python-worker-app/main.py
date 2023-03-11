from initlogging import add_azure_appinsight_logger, add_console_logger
import logging
import datetime
import time
import numpy as np

def do_some_work(iterations:int =100):
    print("Inside function so_some_work")
    for index in range(iterations):
        logging.info(f"Iteration={index}")
        logging.debug("This is a debug log statement")
        logging.info("Inside function so_some_work")
        logging.info(f"hello at {datetime.datetime.now()}")
        arr=np.zeros([5,2])
        logging.info(f"Created array: {arr}")
        time.sleep(0.3)
        logging.info("------------------------------")

if __name__ =="__main__":
    add_console_logger()
    do_some_work()

