import datetime
from appinsights import add_azure_appinsight_logger,add_console_logger
import logging

add_azure_appinsight_logger()
add_console_logger()
now=datetime.datetime.now()
logging.info(f"hello world, now={now.isoformat()}")
logging.info("Hello world program is complete")


