echo "what is the contact email?"

read EMAIL

echo "Running cert setup"
docker build --rm -t docker-apache2:cert . &&
docker run -p 80:80 -d -v "/home/$USER/certbot/site/root:/var/www/html" docker-apache2:cert &&
docker run -it --rm --name certbot \
  -v "/home/$USER/certbot/conf:/etc/letsencrypt" \
  -v "/home/$USER/certbot/www:/var/www/certbot" \
  -v "/home/$USER/certbot/site/root:/var/www/html" \
  certbot/certbot \
  certonly --webroot --email $EMAIL --agree-tos -d $HOST_NAME

&& echo "Get UID from apache docker"
&& echo "run `id`"
&& read UIDIN
&& sudo chown -R $UIDIN:$UIDIN /home/$USER/certbot/conf

&& echo "Finis"