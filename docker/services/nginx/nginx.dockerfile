FROM nginx:1.21

COPY ./sites/*.conf /etc/nginx/conf.d/
COPY ./sites/default.conf.example /etc/nginx/conf.d/default.conf

RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log