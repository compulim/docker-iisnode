# Internet Information Services (IIS) with Node.js and iisnode

This is a Windows Container image. You can find the [Dockerfile](https://github.com/compulim/docker-iisnode/blob/master/Dockerfile) on GitHub.

This [article](https://docs.microsoft.com/en-us/virtualization/windowscontainers/quick-start/quick-start-windows-10) is a quick tutorial for running Docker on Windows 10.

# How to use this image?

## Pull this image from Docker Hub

> Before pulling, make sure your Docker is running in [Windows Container mode](https://docs.docker.com/docker-for-windows/#switch-between-windows-and-linux-containers).

Run `docker pull compulim/iisnode`, to pull the image to your local repository.

## Prepare your Dockerfile

Add the following to your `Dockerfile`. It will copies all your files to `C:\site` and host a new website named "Production Site" on port 8000.

```dockerfile
FROM compulim/compulim-info

ADD . /site
RUN powershell -NoProfile -Command Import-module IISAdministration; New-IISSite -Name 'Production Site' -PhysicalPath C:\site -BindingInformation '*:8000:'
RUN

EXPOSE 8000
```

## Build your own Docker image

Before running your Docker image in a container, you need to use your Dockerfile to build your own Docker image.

Run `docker build -t <your-image-name> <path-to-your-dockerfile>`.

> If you found Docker is taking long time and send many unnecessary files to its daemon, you can add a `.dockerignore` or move your `Dockerfile` deeper inside your file hierarchy.

## Run it on Docker

Run `docker run -p 8000:8000 --name <your-container-name> <your-image-name>`.

This will run the Docker image and expose port 8000.

> To expose as host port 80, replace it with `-p 80:8000`.

To connect to your web server, first, you need to find out the IP address associated to the container.

Run `docker inspect -f "{{ .NetworkSettings.Networks.nat.IPAddress }}" <your-container-name>` and it should display the IP address, for example, 172.25.221.24.

Then browse to [http://172.25.221.24:8000/](http://172.25.221.24:8000/).

# How to enable Failed Request Tracing?

Failed Request Tracing is one of the very powerful diagnostic tool built into IIS.

In this Docker image, we have already installed "Web-Http-Tracing", which is essential for enabling FREB logs.

There are few more steps to enable Failed Request Tracing and view its logs:

1. Enable Failed Request Tracing for the site
2. Create a tracing rule
3. Copy the log and view it locally

## Enable Failed Request Tracing for the site

Run `C:\Windows\system32\inetsrv\appcmd.exe configure trace "Production Site" /enablesite`.

It will enable Failed Request Tracing for site named "Production Site". By default, it will write to `C:\inetpub\logs\FailedReqLogFiles\W3SVC0000000000`, with up to 50 rolling files.

> You can find more information on [TechNet](https://technet.microsoft.com/en-us/library/cc725786(v=ws.10).aspx).

## Create a tracing rule

Add the following to your `web.config`. The rule will enable logging for all possible combinations.

```xml
<tracing>
  <traceFailedRequests>
    <add path="*">
      <traceAreas>
        <add provider="ASP" verbosity="Verbose" />
        <add provider="ASPNET" areas="AppServices,Infrastructure,Module,Page" verbosity="Verbose" />
        <add provider="ISAPI Extension" verbosity="Verbose" />
        <add provider="WWW Server" areas="Authentication,Cache,CGI,Compression,FastCGI,Filter,iisnode,Module,RequestNotifications,Rewrite,Security,StaticFile,WebSocket" verbosity="Verbose" />
      </traceAreas>
      <failureDefinitions statusCodes="200-599" />
    </add>
  </traceFailedRequests>
</tracing>
```

> To find out more providers and areas, you can look them up in `C:\Windows\system32\inetsrv\config\applicationhost.config`, under `/system.webServer/tracing/traceProviderDefinitions`.

## Copy the log and view it locally

> Before you can access the file system in the container, you need to stop the container first. Otherwise, it will show `The process cannot access the file because it is being used by another process. (0x20)` error.

Run `docker cp <your-container-name>:C:\inetpub\logs\FailedReqLogFiles <local-destination-path>` to copy the files to your local drive. The logs need to be translated by XSLT, thus, you need to open them in Internet Explorer.

# Contributions

Like us, please [star](https://github.com/compulim/docker-iisnode/stargazers) us.

If you found an issue or suggest a version bump, please [file an issue](https://github.com/compulim/docker-iisnode/issues) to us.
