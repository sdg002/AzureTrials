[[_TOC_]]

# About
The manual steps neccessary to 
1. Create a new App Service Domain
1. Attach a public facing Azure Container App to a new domain

---

# What is an App Service Domain ?
App Service domains are custom domains that are managed directly in Azure. They make it easy to manage custom domains for Azure App Service. Refer [this Microsoft link](https://learn.microsoft.com/en-us/azure/app-service/manage-custom-dns-buy-domain) for more information



# How to create a DNS Zone in Azure ?

When an **App Service Domain** resource type is created, an instance of **DNS Zone** type is automatically created.
![app-service-domain.png](images/app-service-domain-and-dns-zone.png)

---

# What domain are we creating when we create an App Service Domain ?
We register a top level domain Example: **sau002.co.uk** . This itself does not point to any specific ip address - but just a top level domain.

This will allow us to create sub-domains under contoso.com which map to various Azure Container Apps. Example: **crm.sau002.co.uk** or **crmdev.sau002.co.uk** or **crmprod.sau002.co.uk**

**Attention** - Once the above resources are created you should be able to run `nslookup sau002.co.uk`

![nslookup-top-level.png](images/nslookup-top-level.png)

---

# What does an App Service Domain look like ?

![app-service-domain.png](images/app-service-domain.png)


---

# What does a DNS Zone look like ?

![dns-zone.png](images/dns-zone.png)


---


# Step-1-Create a new child domain 'blahapp'


![add a new child domain](images/domain-001-add-cname-record.PNG)

after adding, there would be a new record

![after adding cname](images/domain-002-after-adding-cname-record.png)

---


# Step-2-Create a new asuid record for 'blahapp'

We need to prove to our DNS registrar (Azure in this case) that we have authority of the targe URL (ACA app in this case). The ACA app provides a digital id (asuid) which should be fed back to the DNS registrar 

**Note** - We create a TXT record with the name **asuid.blahapp** . We have pasted the identity string from the Azure Container App (from the Settings->Custom domains blade of the container app)

![asuid record](images/domain-003-add-asuid.png)


The indentifier string under the **Value** section comes from the Azure Container App's Domain section.
![aca-add-custom-domain.png](images/aca-add-custom-domain.png)

Verify using **nslookup**
```
nslookup blahapp.co.uk
```

Output from nslookup:

```
C:\Users\saurabhd>nslookup blahapp.sau002.co.uk
Server:  cache1.service.virginmedia.net
Address:  194.168.4.100

Non-authoritative answer:
Name:    casaudevuksouth.jollypond-d12792b5.uksouth.azurecontainerapps.io
Address:  52.151.106.199
Aliases:  blahapp.sau002.co.uk
```

We can see that blahapp.sau002.co.uk is redirecting to the internal host name of the container app

---

# Step-3-Attach the new domain to the Azure Container App

##  Custom domain settings of the container app
![custom domain settings blad](images/domain-004-containerapp-custom-domain-settings.png)


## Specify the fully qualified domain name

![aca-add-custom-domain-2](images/aca-add-custom-domain-2.png)


## After Validating and adding the new domain
![after attaching the new domain](images/domain-005-containerapp-after-adding-custom-domain.PNG)

---


# Test-The changes take time to show up
Few minutes.
You can now test by navigating to `blahapp.sau002.co.uk`

---

# ARM templates

## App Service Domain

[See sample](armtemplates/example.appservice.arm.json)


## DNS Zone

[See sample](armtemplates/example.dnszone.arm.json)

The notable features of this ARM template is:
- Every DNS record is a resource in the template
- Take note of how to pass the long custom domain verification identifier string to the TXT record resource of the ARM template
