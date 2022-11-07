FROM php:7.4-fpm
RUN apt-get update && apt-get install -y \
		libfreetype6-dev \
		libjpeg62-turbo-dev \
		libpng-dev \
	&& docker-php-ext-configure gd --with-freetype --with-jpeg \
	&& docker-php-ext-install -j$(nproc) gd

# Multibyte String
RUN apt-get update && apt-get install -y libonig-dev && docker-php-ext-install mbstring

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/

RUN install-php-extensions zip

RUN docker-php-ext-install mysqli pdo pdo_mysql && docker-php-ext-enable pdo_mysql

# Miscellaneous
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
