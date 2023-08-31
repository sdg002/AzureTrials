[[_TOC_]]

# Deploy Azure Alerts using ARM templates - So easy!
# Problem
Consider a very simple business scenario which comprises of web applications and backend services deployed to Azure. Each of these services log their traces and exceptions to Azure Application Insights. The application is deployed across several environments (DEV, UAT, PROD, etc). You have manually created Azure Alerts. But you are finding it onerous to propage the alerts to all the environments. In this article we will see how simple it is to automate the deployment of Azure Alerts and Action Groups via ARM templates.

The primary objective of my writing this article was to dispel the notion that Azure deployment is difficult. On the contrary if you stick to the basics - automation can be a breeze.

[?? to be done] Talk more about the problem
Demonstarte how to display Azure alerts on a MS Teams channel via a web hook.
Talk about the intended audience
Talk about that this appears to be seemingly complex but fairly simple

---

# Link to Source Code

https://github.com/sdg002/AzureTrials/tree/main/azure-alert-msteams-webhook

Structure of the code is as follows
```

├───csharp-webapp <-- Web API to receive calls from Azure alerts
│
├───devops
│   │
|   ├───create_azure_infrastructure.ps1
│   │
│   └───templates  <-- ARM templates
│
└───docs

```

---

# What to expect from this article (to be done) ?
[[a block diagram - with a web app on one side and Azure on other , app insight as a DB, a console EXE which logs to App insights]]
- ARM templates to deply the following
    - Web app
    - Log analytics
    - Application Insights
    - Azure email action group
    - Azure webhook action group
    - Azure alert rule which fires if there are more than 0 exceptions in a 5 minute window
- Create a simple C# console app which logs exceptions to Application Insights
- Create a simple C# web app which receives the web call backs from Azure alerting infrastructure
- PowerShell script to deploy all the Azure templates

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

## Custom JSON Payload is no longer supported
https://github.com/MicrosoftDocs/azure-docs/issues/14571

## Reference to ARM template of Alert Web hook
https://learn.microsoft.com/en-us/azure/templates/microsoft.insights/2017-04-01/actiongroups?pivots=deployment-language-arm-template

## StackOverflow - ARM Template parameter is not working for custom payload json  (customWebhookPayload)
https://stackoverflow.com/questions/70439846/arm-template-parameter-is-not-working-for-custom-payload-json

## Github - Parameters in Custom JSON Webhook Action #40167
https://github.com/MicrosoftDocs/azure-docs/issues/40167

## Approach using Run book as a middleware
https://stackoverflow.com/questions/59883257/azure-monitor-alerts-using-webhook-to-microsoft-teams-no-messages-to-teams

## Azure alert sample payloads
https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-payload-samples


## Github documentation on Azure action group schema
https://github.com/MicrosoftDocs/azure-docs/blob/main/articles/azure-monitor/alerts/alerts-log-webhook.md

## Application Insights alerts no longer have a custom JSON payload option

https://learn.microsoft.com/en-us/answers/questions/800320/application-insights-alerts-no-longer-have-a-custo

---

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