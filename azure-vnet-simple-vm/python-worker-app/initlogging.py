import logging
from opencensus.ext.azure.log_exporter import AzureLogHandler

logger = logging.getLogger(__name__)

def add_azure_appinsight_logger():
    
    azure=AzureLogHandler(
        connection_string='InstrumentationKey=6fea3341-04b8-4a2e-9eb6-b72e562cc6bb')
    azure.setLevel(logging.INFO)
    root=logging.getLogger()
    root.addHandler(azure)

    root.setLevel(logging.INFO)
    # You can also instantiate the exporter directly if you have the environment variable
    # `APPLICATIONINSIGHTS_CONNECTION_STRING` configured
    # logger.addHandler(AzureLogHandler())
    print("Added Application Insight logger")


def add_console_logger():
    logging.basicConfig(level=logging.DEBUG)
    return
