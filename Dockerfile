FROM microsoft/iis
LABEL Description="Internet Information Services (IIS) with Node.js and iisnode" Vendor="Compulim" Version="${NODE_VERSION}"
MAINTAINER compulim@hotmail.com

ADD https://github.com/tjanczuk/iisnode/releases/download/v0.2.21/iisnode-full-v0.2.21-x64.msi /build/iisnode-full-x64.msi
ADD https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-x64.msi /build/node-x64.msi
ADD http://go.microsoft.com/fwlink/?LinkID=615137 /build/rewrite_amd64.msi

RUN powershell Add-WindowsFeature Web-Asp-Net45,Web-Http-Tracing,Web-Scripting-Tools,Web-WebSockets

RUN msiexec /i C:\build\rewrite_amd64.msi /qn /l*v C:\build\urlrewrite.log
RUN msiexec /i C:\build\iisnode-full-x64.msi /qn /l*v C:\build\iisnode.log
RUN msiexec /i C:\build\node-x64.msi /qn /l*v C:\build\node.log
