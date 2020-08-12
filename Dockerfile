FROM ubuntu

RUN apt-get -y update

ENV TZ=Europe/Kiev
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt install -y apache2

RUN a2enmod ssl && a2enmod proxy && a2enmod proxy_http

# RUN  apt-get install -y curl

ADD ./redirect.apache.conf /etc/apache2/sites-available/000-default.conf

EXPOSE 80 443

CMD ["apache2ctl", "-D", "FOREGROUND"]