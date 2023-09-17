# Done
- App plan (done)
- Web app (done)
- Log analytics (done)
- Application insights (done)
- Connect the Web app with the Application insights via INSTRU-KEY (done)
- Skeletal Csharp code (done)
- Deploy the Csharp code (done)
- Configure app insights configured (done)
- GET end point to generate exceptions
- POST end point to capture the payload and write to Application Insights
- Create a manual azure alert which looks for exceptions in a 5 minute window and sends to email action group above
- Test for custom property, examine the JSON
- Deploy Azure alerts using new schema
- Create an action group via Azure ARM which has an email recipient (X)
- Add a web hook action group (X)
- Create an Azure Alert which writes to Web hook as an action group - pass the JSON as it is (X)
- Test the newly deployed Azure alerts (email and web hook) 4 exceptions at 23:12
- You were trying Chat GPT
- Change Catching end point to a custom controller (AzureAlertWebHook)
- ms team - Change web hook end point in Azure Action Group
- ms team - c# Read the Web hook from Azure Payload
- Write a new web hook which relays the call to MS teams

# Under progress
- Readme.md refinement (you finished what to expect?)

# To be done
- Document the C# Console EXE
- Intercept the JSON 1)Read the URL of the Teams Channel from the extra properties 2)Invoke the web hook
- Alert processing rules
---

# Current status
- You tidies up the README.MD sections with (to be done)
- 
# Not doing
- Create an Azure alert with an old schema (look in github for custom json paylo)
- Manuall modify the JSON payload
- Test manual web hook with MS Teams
- Script the manual azure alert via ARM template (X)
- Modify action group to convert JSON payload (X)
