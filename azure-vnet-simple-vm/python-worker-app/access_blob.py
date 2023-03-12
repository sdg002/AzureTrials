import logging
import os
import traceback
from azure.storage.blob import BlobServiceClient
from env_variables import EnvironmentVariables

def list_blob_containers():
    logging.info("Going to access some blobs")
    try:
        logging.info(f"Going to get environment variable {EnvironmentVariables.STORAGE_ACCOUNT_NAME} and {EnvironmentVariables.STORAGE_ACCOUNT_KEY}")

        storage_account_name=os.environ[EnvironmentVariables.STORAGE_ACCOUNT_NAME]
        account_url=f"https://{storage_account_name}.blob.core.windows.net"
        storage_key=os.environ[EnvironmentVariables.STORAGE_ACCOUNT_KEY]

        logging.info(f"Going to query Storage account name:{storage_account_name} , key:{storage_key}")
        service = BlobServiceClient(account_url=account_url, credential=storage_key)
        containers = service.list_containers()
        for container in containers:
            logging.info(f"Got a container:{container.name}")
        pass
    except Exception as ex:
        logging.error(f"{str(ex)}")
        logging.error(traceback.format_exc())
    pass
