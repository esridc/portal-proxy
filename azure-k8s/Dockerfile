FROM nginx

RUN apt-get update && apt-get install -y openssl

RUN mkdir -p /etc/nginx/ssl
RUN mkdir -p /etc/nginx/sites-enabled
RUN mkdir -p /srv/www/portal/errors

RUN openssl req \
  -new \
  -newkey rsa:4096 \
  -days 365 \
  -nodes \
  -x509 \
  -keyout "/etc/nginx/ssl/portal.key" \
	-out "etc/nginx/ssl/portal.crt" \
  -subj "/C=US/ST=District of Columbia/L=Washington, DC/O=DC R&D Center/CN=aks.demo-gis.com"

COPY nginx.conf /etc/nginx
COPY portal.conf /etc/nginx/sites-enabled
COPY ui-404.html /srv/www/portal/errors/ui-404.html
