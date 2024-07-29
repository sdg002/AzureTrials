[[_TOC_]]

# Create a image from a Docker file
This assumes you are in the folder which has a `Dockerfile` already
```powershell
docker build .\ -t junkpython
```

---

# Run a docker image

```powershell
docker run --rm --env name1=value1 --env name2=value2 junkpython
```

# Do not use print, use logging.info
The `print` statement will hold on to the buffer for a long time