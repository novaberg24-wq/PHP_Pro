# Use PHP 8.2 official image
FROM php:8.2-cli

# Set working directory
WORKDIR /app

# Copy app files into container
COPY . /app

# Install Composer (optional, if you use it)
RUN apt-get update && apt-get install -y unzip git \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install dependencies if composer.json exists
RUN if [ -f "composer.json" ]; then composer install; fi

# Expose Render's required port
EXPOSE 10000

# Start PHP's built-in server
CMD ["php", "-S", "0.0.0.0:10000", "-t", "public"]
