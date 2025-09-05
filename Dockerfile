# Use PHP 8.2 with Composer
FROM php:8.2-cli

# Set working directory
WORKDIR /app

# Install required system packages and PHP extensions
RUN apt-get update && apt-get install -y unzip git curl libzip-dev \
    && docker-php-ext-install zip pdo pdo_mysql

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php \
    -- --install-dir=/usr/local/bin --filename=composer

# Copy project files
COPY . /app

# Install PHP dependencies
RUN composer install --no-interaction --prefer-dist --optimize-autoloader

# Expose Render's port
EXPOSE 10000

# Start PHP server (change public to root if needed)
CMD ["php", "-S", "0.0.0.0:10000", "-t", "public"]
