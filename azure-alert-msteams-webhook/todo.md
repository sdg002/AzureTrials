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

# Under progress
- Test the newly deployed Azure alerts (email and web hook) 4 exceptions at 23:12

# To be done
- Create an Azure alert with an old schema (look in github for custom json paylo)
- Manuall modify the JSON payload
- Test manual web hook with MS Teams
- Script the manual azure alert via ARM template (X)
- Inspect JSON payload (X)
- Modify action group to convert JSON payload (X)

---

# Current status
You generated 2-3 exceptions at 10.28 PM
