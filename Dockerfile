FROM php:8.2-cli

WORKDIR /app

# Install dependencies for Composer + common PHP extensions
RUN apt-get update && apt-get install -y \
    unzip git curl libzip-dev libpng-dev libonig-dev libxml2-dev \
    && docker-php-ext-install \
        zip \
        pdo \
        pdo_mysql \
        mbstring \
        gd \
        intl \
        xml \
        bcmath

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php \
    -- --install-dir=/usr/local/bin --filename=composer

# Copy project files
COPY . /app

# Run composer with verbose logging
RUN composer install --no-interaction --prefer-dist --optimize-autoloader -vvv

EXPOSE 10000

CMD ["php", "-S", "0.0.0.0:10000", "-t", "public"]
