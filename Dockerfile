FROM php:8.2-cli

WORKDIR /app

# Install system dependencies required by PHP extensions
RUN apt-get update && apt-get install -y \
    unzip git curl libzip-dev libpng-dev libicu-dev libxml2-dev libonig-dev pkg-config libjpeg-dev libfreetype6-dev g++ make autoconf \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
        zip \
        pdo_mysql \
        mbstring \
        gd \
        intl \
        bcmath

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php \
    -- --install-dir=/usr/local/bin --filename=composer

# Copy project files
COPY . /app

# Install PHP dependencies with verbose logging
RUN composer install --no-interaction --prefer-dist --optimize-autoloader -vvv || cat /app/composer.log

EXPOSE 10000

# Start PHP server (adjust if your entrypoint is not public/index.php)
CMD ["php", "-S", "0.0.0.0:10000", "-t", "public"]
