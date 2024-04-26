import logging
import datetime

import azure.functions as func


def main(req: func.HttpRequest) -> func.HttpResponse:
    utc_timestamp = datetime.datetime.utcnow().replace(
        tzinfo=datetime.timezone.utc).isoformat()

    logging.info(f'Python HTTP trigger function processed a request. at {utc_timestamp}')

    name = req.params.get('name')
    if not name:
        try:
            req_body = req.get_json()
        except ValueError:
            pass
        else:
            name = req_body.get('name')

    if name:
        return func.HttpResponse(f"Hello, {name}. This HTTP triggered function executed successfully.")
    else:
        return func.HttpResponse(
             f"This HTTP triggered function executed successfully. Pass a name in the query string or in the request body for a personalized response., time={utc_timestamp}",
             status_code=200
        )
