# Base
FROM php:8.3.7-apache-bookworm

# Define workdir
WORKDIR /var/www/html

RUN apt-get update && apt-get install -y \
    # Used by entrypoint
    acl \
    # Used by Symfony CLI
    git \
    # intl dependancy
    libicu-dev \
    # usefull to edit files
    nano \
    # Used to install composer
    wget \
    # Used with Symfony bundle
    libzip-dev \
    # Used by composer
    zip

# Apache modules
RUN a2enmod \
    rewrite \
    expires \
    headers

# Extension PHP
RUN docker-php-ext-install \
    # a PHP accelerator should be installed
    opcache \ 
    # mysql driver
    pdo_mysql \
    # intl extension should be available (used for validators)
    intl \
    # Used with Symfony bundle
    zip

# Copy php.ini
RUN cp /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini \
    # short_open_tag should be disabled in php.ini
    && echo 'short_open_tag = Off' >> /usr/local/etc/php/php.ini 

# Add vhost
COPY ./automation/docker/default-vhost.conf /etc/apache2/sites-available/
RUN a2dissite 000-default.conf \
    && a2ensite default-vhost.conf 

# Install Symfony CLI
RUN wget https://get.symfony.com/cli/installer -O - | bash \
    && chmod +x /root/.symfony5/bin/symfony \
    && mv /root/.symfony5/bin/symfony /usr/local/bin/symfony

# Install Composer
COPY ./automation/scripts/composer-setup.sh /tmp
RUN bash /tmp/composer-setup.sh

# Install APCU
RUN pear config-set http_proxy "${http_proxy}" \
    && pecl channel-update pecl.php.net \
    && pecl install apcu
RUN echo "extension=apcu.so\napc.enable_cli=on" > /usr/local/etc/php/conf.d/apcu.ini

# Install X-Debug
RUN pecl install xdebug-3.3.2 \
    && echo 'xdebug.mode=develop,debug,coverage' >> /usr/local/etc/php/php.ini \
    && echo 'xdebug.client_host=host.docker.internal' >> /usr/local/etc/php/php.ini \
    && docker-php-ext-enable xdebug

# Clean the mess
RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add Entrypoint
COPY ./automation/scripts/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Run
CMD ["/usr/local/bin/docker-entrypoint.sh"]
