from initlogging import add_azure_appinsight_logger, add_console_logger
import logging
import datetime
import time
import numpy as np
from access_blob import list_blob_containers
import socket
import os


def display_separator():
    logging.info("---------------------------------------")

def display_environment_variables():
    display_separator()
    for variable_name in os.environ.keys():
        variable_value=os.environ[variable_name]
        logging.info(f"{variable_name}={variable_value}")
    pass

def display_ip_address():
    display_separator()
    logging.info("Going to display the IP address of the client")
    hostname = socket.gethostname()
    logging.info(f"The host name is {hostname}")
    ip_address = socket.gethostbyname(hostname)
    logging.info(f"IP Address: {ip_address}")
    pass

def do_some_work(iterations:int =5):
    print("Inside function so_some_work")
    for index in range(iterations):
        logging.info(f"Iteration={index}")
        logging.debug("This is a debug log statement")
        logging.info("Inside function so_some_work")
        logging.info(f"hello at {datetime.datetime.now()}")
        arr=np.zeros([5,2])
        logging.info(f"Created array: {arr}")
        time.sleep(0.3)
        display_separator()

if __name__ =="__main__":
    add_console_logger()
    display_environment_variables()
    do_some_work(iterations=2)
    display_ip_address()
    list_blob_containers()
