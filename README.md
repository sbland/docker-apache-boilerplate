# Docker apache Setup

This is a boilerplate docker ssl apache setup.
It will copy the redirect.apache.conf file to the docker container.


## SSL Certificate setup
The certificate must be obtained for the virtual machine.
First redirect the host address to the machines public IP
Then follow the instructions below.

run `./cert_setup/certSetup.sh`

or...


We need to run certbot setup using the certbot docker container

- In certbot directory
- docker build --rm -t docker-apache2:cert .
- docker run -p 80:80 -v "/home/$USER/certbot/<SITE>/root:/var/www/html" docker-apache2:cert
- Then run certbot:
```
EMAIL=<EMAIL> && HOST_NAME=<HOST_NAME> &&
docker run -it --rm --name certbot \
  -v "/home/$USER/certbot/conf:/etc/letsencrypt" \
  -v "/home/$USER/certbot/www:/var/www/certbot" \
  -v "/home/$USER/certbot/<SITE>/root:/var/www/html" \
  certbot/certbot \
  certonly --webroot --email $EMAIL --agree-tos -d $HOST_NAME
# Webroot is /var/www/html
```
- Set file access to /home/$USER/certbot/conf to allow apache server access
  - get Apache server UID by attaching a shell to the apache docker `docker exec -it <container name> /bin/bash`
  - and running  `id` normally 0
  - `sudo chown -R <UID>:<UID> /home/$USER/certbot/conf `
  - Then re build docker-apache2
    - `docker build --rm -t docker-apache2:latest .`
    - `docker run -p 443:443 -e HOST_NAME=$HOST_NAME -e PROXYCLIENTNAME=node_server -v "/home/$USER/certbot/conf:/etc/letsencrypt" docker-apache2`
  - or proceed to docker compose
