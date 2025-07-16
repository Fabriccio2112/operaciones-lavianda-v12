#!/bin/bash
# Script de instalación para servidor Plesk
# Guardar como install.sh y ejecutar en el servidor

echo "🚀 Iniciando instalación de Laravel en Plesk..."

# Ir al directorio del proyecto
cd /var/www/vhosts/$(hostname)/httpdocs

# Instalar dependencias
echo "📦 Instalando dependencias..."
composer install --no-dev --optimize-autoloader

# Configurar permisos
echo "🔐 Configurando permisos..."
chmod -R 755 storage/
chmod -R 755 bootstrap/cache/

# Generar clave de aplicación
echo "🔑 Generando clave de aplicación..."
php artisan key:generate --force

# Ejecutar migraciones
echo "📊 Ejecutando migraciones..."
php artisan migrate --force

# Crear usuarios de prueba
echo "👥 Creando usuarios de prueba..."
php artisan db:seed --class=UserSeeder --force

# Optimizar para producción
echo "⚡ Optimizando para producción..."
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Crear enlace simbólico
echo "🔗 Creando enlace de storage..."
php artisan storage:link

echo "✅ ¡Instalación completada!"
echo "🌐 Tu API está disponible en: https://$(hostname)/api/"
echo "📋 Usuarios de prueba:"
echo "   - admin@ejemplo.com / 12345678 (admin)"
echo "   - empleado@ejemplo.com / 12345678 (empleado)"
