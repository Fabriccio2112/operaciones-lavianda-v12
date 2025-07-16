# Script para preparar Laravel para producción
Write-Host "Preparando Laravel para producción..." -ForegroundColor Green

# 1. Limpiar caché
Write-Host "1. Limpiando caché..." -ForegroundColor Yellow
php artisan config:clear
php artisan cache:clear
php artisan view:clear
php artisan route:clear

# 2. Optimizar para producción
Write-Host "2. Optimizando para producción..." -ForegroundColor Yellow
php artisan config:cache
php artisan route:cache
php artisan view:cache

# 3. Instalar dependencias sin dev
Write-Host "3. Instalando dependencias de producción..." -ForegroundColor Yellow
composer install --no-dev --optimize-autoloader

Write-Host "Preparación completada!" -ForegroundColor Green
Write-Host ""
Write-Host "Archivos a subir al servidor:" -ForegroundColor Cyan
Write-Host "- Toda la carpeta del proyecto EXCEPTO:" -ForegroundColor Gray
Write-Host "  - node_modules/" -ForegroundColor Red
Write-Host "  - .env (crear uno nuevo en el servidor)" -ForegroundColor Red
Write-Host "  - storage/logs/*.log" -ForegroundColor Red
Write-Host "  - vendor/ (si usas Composer en el servidor)" -ForegroundColor Red
