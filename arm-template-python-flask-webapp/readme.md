# Deploy a Python Flask Web app to Azure using ARM templates and Azure CLI

# About
This is a step by step guide to deploy a very simple Python Flask Web app

# Structure of the code
```
    - azuredevops
        |
        |--deploy.ps1
        |
        |--cicd.yml
        |
    - webapp-source
        |
        |--app.py
        |
        |--requirements.txt
        |
        |
    - docs
        |
        |--variables.ps1
        |

```

---

# your progress is here
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
    - ARM-key vault
    - Python-hello world code
    - ARM-application insights (optional)
    - ARM-log analytics(optional)
    - Python-logging code using OpenCensus
- Web app-round 2
    - PYTHON-A custom page which reads static text from storage account (some popular text)
- Web app - Flask Advanced
    - simple form to save document to storage account
    - simple form to read from storage account
    - Create App service plan
    - Create web app, pass app settings, raw environment value
    - Create web app, pass app settings, key vault reference
- ??

