[[_TOC_]]

# Redirecting Azure Alerts to a Microsoft Teams channel (using ARM templates)
# Problem
You have applications that log to Azure Application Insights.
[?? to be done] Talk more about the problem
Demonstarte how to display Azure alerts on a MS Teams channel via a web hook.
Talk about the intended audience
Talk about that this appears to be seemingly complex but fairly simple

---

# Link to Source Code
To be done
- Pointed to ARM template
- Pointer to C# web app for capturing Azure Alerts via web hook
---

# What to expect from this article ?
- Create the neccessary Azure resources for a web app (this includes ????)
- Create a simple C# web app which logs to App Insights
- Deploy an Azure ARM template which alerts for exceptions to an email recipients
- We will extend the Azure ARM templat to redirect the alerts to a Microsoft Teams channels

# Understanding Azure Alerts and Action Groups
to be done . Show a block diagram depicting Alert leading to multiple action groups

---
# How to deploy an Azure alert using ARM template ?
to be done

---

# How to deploy an email Action group using ARM template ?
Cheating using the UI
to be done

---

# How to deploy a web hook action group using ARM template ?
Cheating using the UI
to be done

---

# How to write any information to a MS Teams channel using out of box REST end points ?
To be done
- MS teams
- Grab the REST end point of your Teams channel
- Show the structure of the REST end point (fudge the secure bits)

---

# How to influence the JSON structure of the Azure Alert payload before publishing to a MS teams channels ?
to be done


# Structure of the repo (improve this)

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
---

# How to execute the code ?
Caveat on Azure subscription with billing.


---

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