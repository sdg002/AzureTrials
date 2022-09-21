import datetime
from appinsights import add_azure_appinsight_logger,add_console_logger
import logging
import os

add_azure_appinsight_logger()
add_console_logger()
now=datetime.datetime.now()
logging.info(f"hello world, now={now.isoformat()}")

logging.info("Displaying all environment variables ")
allvars=list(os.environ.keys())
for var in allvars:
    logging.info(f"\t{var}={os.environ[var]}")

logging.info("Hello world program is complete")


