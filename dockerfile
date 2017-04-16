FROM microsoft/iis
LABEL Description="Internet Information Services (IIS) with iisnode and Node.js" Vendor="Compulim" Version="1"
MAINTAINER compulim@hotmail.com

ADD https://github.com/tjanczuk/iisnode/releases/download/v0.2.21/iisnode-full-v0.2.21-x64.msi /build/iisnode-full-x64.msi
ADD https://nodejs.org/dist/v7.9.0/node-v7.9.0-x64.msi /build/node-x64.msi
ADD http://go.microsoft.com/fwlink/?LinkID=615137 /build/rewrite_amd64.msi

RUN powershell Add-WindowsFeature Web-Http-Tracing
RUN powershell Add-WindowsFeature Web-Asp-Net45
RUN powershell Add-WindowsFeature Web-Scripting-Tools
RUN powershell Add-WindowsFeature Web-WebSockets

RUN msiexec /i C:\build\rewrite_amd64.msi /qn /l*v C:\build\urlrewrite.log
RUN msiexec /i C:\build\iisnode-full-x64.msi /qn /l*v C:\build\iisnode.log
RUN msiexec /i C:\build\node-x64.msi /qn /l*v C:\build\node.log
