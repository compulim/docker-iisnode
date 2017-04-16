# Internet Information Services (IIS) with iisnode and Node.js

This is a Windows container image.

# How to use this image?

Add the following to your `dockerfile`. It will copies all your files to `C:\site` and host a new website named "Production Site" on port 8000.

```dockerfile
FROM compulim/compulim-info

ADD . /site
RUN powershell -NoProfile -Command Import-module IISAdministration; New-IISSite -Name 'Production Site' -PhysicalPath C:\site -BindingInformation '*:8000:'
RUN

EXPOSE 8000
```

Once the container starts, you'll need to finds its IP address so that you can connect to your running container from a browser. You use the docker inspect command to do that:

```
docker inspect -f "{{ .NetworkSettings.Networks.nat.IPAddress }}" my-running-site
```

You will see an output similar to this:

```
172.28.103.186
```

You can connect the running container using the IP address and configured port, http://172.28.103.186:8000 in the example shown.
