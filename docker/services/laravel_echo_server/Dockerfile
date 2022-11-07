FROM node:18-alpine

WORKDIR /var/www/laravel_echo_server

COPY echo.json /var/www/laravel_echo_server/echo.json
COPY laravel-echo-server.json /var/www/laravel_echo_server/laravel-echo-server.json

RUN npm install -g pm2 laravel-echo-server

EXPOSE 6001

CMD ["pm2-runtime", "echo.json"]
