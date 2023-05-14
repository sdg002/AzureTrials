[[_TOC_]]

# Deploy a Python Flask Web app to Azure using ARM templates and Azure CLI

# About
This is a step by step guide to deploy a very simple Python Flask Web app. [??Link to first part of the article on Azure ARM]

# Link to source code
[?? link to the Github repo]

# 100-Structure of the code
[?? you will need to revisit this section , you have moved 501 to under the root level]
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

## Step 1-Create a new folder
```
    root
        |
        |
        |
        - 400-create-hello-world-flask-app-manually
        |        |
        |        |--app.py
        |        |
        |        |--requirements.txt
        |        |
        |

```

## Step 2-Launch VS Code with the new folder
When working with Python and VS Code, I find it more convenient to keep the Python sources in a separate tree and have VS Code open that tree exlusively. Therefore, launch a fresh instance of `VS Code` and open the folder `400-create-hello-world-flask-app-manually` . This will be serve as the root folder of our `Hello world` Flask app


## Step 3-Create a new VENV

![vscode-create-venv.png](docs/images/vscode-create-venv.png)

Give this step some time. Say 30 seconds or so. After this, you should new folder `.venv` . This is automatically excluded because of a .gitignore that was automatically created within

## Step 4-Create a requirements.txt
The file requirements.txt will contain all the packages that the App needs. To start with just add the `Flask` package

```
flask
```

## Step-5-Install the packages

```PowerShell
pip install -r .\requirements.txt
```

## Step 4-Create a new file app.py
```python
from flask import Flask
import datetime
app = Flask(__name__)

@app.route("/")
def home():
    return f"Hello, Flask! Current clock time is: {datetime.datetime.utcnow()}"

```

## Step 5-Launch the Flask web app
Run the following command from the `Terminal` window of `VS Code`
```powershell
python -m flask run
```

![run-flask-webapp-0.png](docs/images/run-flask-webapp-0.png)

![run-flask-webapp.png](docs/images/run-flask-webapp-1.png)

## Microsoft reference
https://code.visualstudio.com/docs/python/tutorial-flask



# 500-Deploying the Hello World Flask Web App to Azure (using ARM templates)
[?? list down the elements]
[?? Describe what is an App Service Plan and what is Web App]

## 501-Create a App Service Plan
[?? Azure cli and arm json]

## 502-Create a Storage Account
[?? Azure cli and arm json]

## 503-Create the Web App
[?? Azure cli and arm json]

## 505-Deploy the Python code to the Web App


---

# References

## Creating a Python Flask App using VS Code
https://code.visualstudio.com/docs/python/tutorial-flask

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

