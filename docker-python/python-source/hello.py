import datetime
from appinsights import add_azure_appinsight_logger,add_console_logger
import logging
import os

add_azure_appinsight_logger()
add_console_logger()
start_time=datetime.datetime.now()
logging.info(f"hello world, now={start_time.isoformat()}")

logging.info("Displaying all environment variables ")
allvars=list(os.environ.keys())
for var in allvars:
    logging.info(f"\t{var}={os.environ[var]}")

end_time=datetime.datetime.now()
elapsed=start_time-end_time
logging.info(f"Hello world program is complete at {end_time.isoformat()}, Elapsed={elapsed.total_seconds()} seconds")


