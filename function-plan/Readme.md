# What is this project about?
Demonstrates how to deploy an Azure function consumption plan

# How is it happening?
There is an ARM template, which has been stripped off ApplicationInsights and Function App. The ARM template is being deployed with right parameters

# Where did I get this ARM template?
https://docs.microsoft.com/en-us/azure/azure-functions/functions-create-first-function-resource-manager?tabs=visual-studio-code%2Cazure-cli

# How to run?
- Open a PowerShell core session
- Ensure you have the Az.Functions module
- Ensure you have done a `Connect-AxAccount`
- Navigate to this folder
- Run `deploy.ps`
