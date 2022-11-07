FROM php:7.2-fpm

# RUN apt-get -y install gcc make autoconf libc-dev pkg-config libzip-dev

RUN apt-get update && apt-get install -y

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/

RUN install-php-extensions zip

RUN pecl install redis && docker-php-ext-enable redis

RUN docker-php-ext-install mysqli pdo pdo_mysql && docker-php-ext-enable pdo_mysql

# # Miscellaneous
RUN docker-php-ext-install bcmath
RUN docker-php-ext-install exif
RUN docker-php-ext-install pdo_mysql

RUN echo "file_uploads = On\n" \
    "memory_limit = 500M\n" \
    "upload_max_filesize = 500M\n" \
    "post_max_size = 500M\n" \
    "max_execution_time = 600\n" \
    > /usr/local/etc/php/conf.d/uploads.ini
    
# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install specific version of Node.js with npm through nvm
SHELL ["/bin/bash", "--login", "-c"]
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
RUN nvm install --lts

# Install Cron
RUN apt-get update && apt-get install -y cron
RUN echo "* * * * * root php /var/www/artisan schedule:run >> /var/log/cron.log 2>&1" >> /etc/crontab
RUN touch /var/log/cron.log

CMD bash -c "cron && php-fpm"