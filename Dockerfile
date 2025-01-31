FROM php:8.2-fpm

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    curl \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql

# Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Configuración de Laravel
WORKDIR /var/www
COPY . .
RUN composer install --no-dev --optimize-autoloader

# Establecer permisos
RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache

# Exponer puerto para PHP-FPM
EXPOSE 9000

CMD ["php-fpm"]
