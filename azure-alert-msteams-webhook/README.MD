[[_TOC_]]

# Overview
Demonstarte how to display Azure alerts on a MS Teams channel via a web hook.

# Structure

```

----
    |
    |
    |
    ----devops
    |
    |
    |
    ----csharp
    |
    |
    README.MD
    |
    |
    cicd.yml
    |
    |
    build-template.yml
    |
    |
    release-template.yml
    

```

# To be done
- App plan (done)
- Web app (done)
- Log analytics (done)
- Application insights (done)
- Connect the Web app with the Application insights via INSTRU-KEY (done)
- Skeletal Csharp code (done)
- Deploy the Csharp code (done)
- Configure app insights configured (X)
- POST end point to capture the payload and write to application insights (X)
- Create an Azure Alert which writes to Web hook as an action group - pass the JSON as it is (X)

# References


## MS documentation on Azure actions for web hooks
https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-log-webhook


## ARM template - How to reference the instrumentation key in the app settings of Web App ?
Example:
```json
                    "appSettings": [
                        {
                            "name" : "APPLICATIONINSIGHTS_CONNECTION_STRING",
                            "value" : "[reference(resourceId(subscription().subscriptionId, resourceGroup().name,'microsoft.insights/components','name_of_my_appinsightresource'),'2015-05-01').ConnectionString]"
                        }      
                    ]
```

# Lessons learnt
## How to let Azure know that you are deploying a dotnet core app ?
The parameter  `linuxFxVersion` should be specified. Example: via the parameters file is one of the options
```
    "linuxFxVersion": 
    {
            "value": "DOTNETCORE|7.0"
    }
```

## How to let Azure not initiate a build from your code ?

Since we are deploying a dotnet core application, there is no need to do an online build (unlike Python). We should specify SCM_DO_BUILD_DURING_DEPLOYMENT as 0

```
"appSettings": [
    {
        "name" : "SCM_DO_BUILD_DURING_DEPLOYMENT",
        "value" : "0"
    }
]
```