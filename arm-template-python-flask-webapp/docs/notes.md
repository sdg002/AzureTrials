# your progress is here
## Next steps
- Remove the storage account creation from section 500
- Add a 506 - "Putting it all together" which does all the deployment
- DO THE FOLLOWING IN SUBSEQUENT PROJECT (for now tidy up the readme.md and publish it, add some pictures)
- New section 600 - Add logging and write some logging code in app.py, log to Terminal window
- 601 - flask app that has logging to Application Insights and 
- 602 Add `Log Analytics` and `Application Insights`
- 603- Add InstrumentationKey to web app settings
- Test if logging works
- 

## Broad ideas

- Web app - Flask Basic without Azure
    - Hello world page, show current date time
    - No secrets
    - Just plan
    - Just web app
    - A folder with requirements.txt, Dockerfile
- Web app-round 1
    - Create resource group
    - POWERSHELL-Create a new variables.ps1 and link with deploy.ps1
    - ARM-app service plan
    - ARM-web app
    - ARM-storage account
    - Python-hello world code
    - Python-logging code using OpenCensus
- Web app-round 2
    - ARM-application insights (optional)
    - ARM-log analytics(optional)
    - PYTHON-A custom page logs the current date and time to Applicaiton Insights
- Web app-round 3
    - ARM-key vault
    - PYTHON-A custom page which reads static text from storage account (some popular text)
- Web app - Flask Advanced
    - simple form to save document to storage account
    - simple form to read from storage account
    - Create App service plan
    - Create web app, pass app settings, raw environment value
    - Create web app, pass app settings, key vault reference
- ??

