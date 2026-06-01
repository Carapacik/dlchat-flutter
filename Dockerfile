FROM registry.fly-teh.ru/nginx:1.25.2-alpine

RUN chmod g+rw  /var/log/nginx /var/cache/nginx /var/run 

COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf
COPY ./nginx/nginx.conf /etc/nginx/nginx.conf

COPY build/web /srv/app

RUN chmod -R 755 /srv/app

EXPOSE 8080