[[_TOC_]]

# Deploy a Python Flask Web app to Azure using ARM templates and Azure CLI

# About
This is a step by step guide to deploy a very simple Python Flask Web app. [??Link to first part of the article on Azure ARM]

# Link to source code
[?? link to the Github repo]

# 100-Structure of the code
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
        |--pics
        |

```

# 200-How to be productive with PowerShell and Python in the same repository ?
to be done?? [state the problem. propose the solution - divide and conquer]

# 300-Creating a very simple Python Flask Web App
[No azure here, just a self container hello world Flask app, with one page which shows the time]
Some notes on debugging
??

# 400-Creating a Hello World Azure Web App manually
[?? Talk about what you need to deploy , create a web app manuall and show all the elements]

[?? list down the elements]
[?? Describe what is an App Service Plan and what is Web App]

# 500-Deploying the Hello World Flask Web App to Azure (using ARM templates)
## 501-Create a App Service Plan
[?? Azure cli and arm json]

## 503-Create a Storage Account
[?? Azure cli and arm json]

## 504-Create the Web App
[?? Azure cli and arm json]

## 505-Deploy the Python code to the Web App


---

# References

## UP command
[??to be done]



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

