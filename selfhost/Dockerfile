# escape=`

FROM compulim/iisnode
LABEL Description="Self-host test for compulim/iisnode image" Vendor="Compulim" Version="1"
MAINTAINER compulim@hotmail.com

ADD wwwroot C:\site
RUN powershell -NoProfile -Command Import-module IISAdministration; New-IISSite -Name 'Production Site' -PhysicalPath C:\site -BindingInformation '*:8000:'
RUN C:\Windows\system32\inetsrv\appcmd.exe configure trace "Production Site" /enablesite

EXPOSE 8000
