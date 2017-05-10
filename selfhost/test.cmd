docker stop iisnode-selfhost
docker rm iisnode-selfhost
docker rmi compulim/iisnode-selfhost
docker build -t compulim/iisnode-selfhost .
docker run -d -p 8000:8000 --name iisnode-selfhost compulim/iisnode-selfhost
docker inspect -f "{{ .NetworkSettings.Networks.nat.IPAddress }}" iisnode-selfhost
