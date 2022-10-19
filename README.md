# docker-base

Step1: copy file .env.example to .env

Step2: Set your path for APP_CODE_PATH_HOST=Your_Local_Folder in env

Step3: sudo chmod -R 777 docker.sh

Step4: Run command ./docker.sh start 

Step5: Create virtual host for virtual domain in nginx

Create new file docker/services/nginx/sites/api.kakei.conf

Paste this content

server {
    listen 80;

    server_name api.kakei.dev.com;
    root /var/www/kakei-api/public;
    index index.php index.html index.htm;

    location / {
         try_files $uri $uri/ /index.php$is_args$args;
    }

    location ~ \.php$ {
        try_files $uri /index.php =404;
        fastcgi_pass php7.3:9000;
        fastcgi_index index.php;
        fastcgi_buffers 16 16k;
        fastcgi_buffer_size 32k;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_read_timeout 600;
        include fastcgi_params;
    }

    location ~ /\.ht {
        deny all;
    }

    location /.well-known/acme-challenge/ {
        root /var/www/letsencrypt/;
        log_not_found off;
    }
    gzip on;    
    client_max_body_size 25m;
}

