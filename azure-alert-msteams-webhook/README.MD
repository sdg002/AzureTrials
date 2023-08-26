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
- Connect the Web app with the Application insights via INSTRU-KEY
- Csharp code
- Deploy
- POST end point to capture the payload and write to application insights

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
