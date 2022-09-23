# References

## Setting up a virtual environment with VS Code

https://code.visualstudio.com/docs/python/environments

## Ensure that you activate the VENV
```powershell
.venv\Scripts\activate.bat
```


## Installing OpenCensus package for Application Insights

```
python -m pip install opencensus-ext-azure
```

## Updating the requirements.txt

```
pip freeze > requirements.txt 
```


---

# Build a Python Docker image

## Online documentation
https://hub.docker.com/_/python

## Which image for 3.9 ?
3.9
---

## Sample Docker file
```dockerfile
FROM python:3

WORKDIR /usr/src/app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD [ "python", "./your-daemon-or-script.py" ]
```


# Docker commands


## List all images
```powershell
docker images
```

What to expect:
```
REPOSITORY        TAG                  IMAGE ID       CREATED         SIZE
pythondemo        latest               ccf9191a139a   6 minutes ago   182MB
jenkins/jenkins   2.289.3-lts-centos   219e37fa7afb   13 months ago   875MB

```

## Delete an image 
```powershell
docker rmi <image tag>
```

## Create a image from a Docker file
This assumes you are in the folder which has a `Dockerfile` already
```powershell
docker build .\ -t pythondemo
```

## Run a docker image

```powershell
docker run --rm --env name1=value1 --env name2=value2 saupythonhello
```

# Referenecs
## How to PIP UNINSTALL all?

```powershell
pip freeze > junklist.txt
pip uninstall -r junklist.txt --quiet
```

## Upload a local docker image
Good article by some Sahil Mallik
https://winsmarts.com/push-a-docker-image-into-the-azure-container-registry-using-azure-cli-c71bf2f3c3a

## Creating a managed identity
```powershell
function CreateManagedIdentity{
    & az identity create --name $Global:AcrIdentity --resource-group $Global:ResourceGroup
    ThrowErrorIfExitCode -message "Could not create managed identity $Global:AcrIdentity"
}

```