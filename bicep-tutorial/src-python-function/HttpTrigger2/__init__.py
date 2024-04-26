import logging
import datetime

import azure.functions as func
import os


#
#This Http trigger demonstrates how to read files from a mounted file share
#
#

def main(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request.')
    utc_timestamp = datetime.datetime.utcnow().replace(
        tzinfo=datetime.timezone.utc).isoformat()

    env_name="MOUNTEDSHARENAME"
    share=os.environ.get(env_name, None)
    if share is None:
        return func.HttpResponse(f"Could not find the environment variable {env_name=}")
    #share="/hello123"
    files_in_share = os.listdir(share)
    response=""
    response=response+ f"Going to read files in  {share} \n"
    response=response+ f"Found {len(files_in_share)} files \n"
    for file in files_in_share:
        response=response+ f"Found file: {file}\n"
    response=response+f"Current time is {utc_timestamp}"
    return func.HttpResponse(response)
