# ✅ Checklist de Deployment a Plesk

## **Antes de subir:**
- [ ] Ejecutar `.\prepare-production.ps1`
- [ ] Verificar que todos los tests pasan: `php artisan test`
- [ ] Crear copia del proyecto sin archivos innecesarios
- [ ] Preparar archivo `.env.production` con datos reales

## **En Plesk - Configuración inicial:**
- [ ] Crear base de datos MySQL
- [ ] Anotar credenciales de BD (host, nombre, usuario, password)
- [ ] Configurar dominio con Document Root en `/public`
- [ ] Activar PHP 8.2+
- [ ] Verificar extensiones PHP necesarias

## **Subida de archivos:**
- [ ] Subir proyecto via FTP/SFTP o File Manager
- [ ] Excluir: `.env`, `node_modules/`, `storage/logs/*.log`
- [ ] Verificar estructura de directorios correcta

## **Configuración en servidor:**
- [ ] Crear archivo `.env` con datos de producción
- [ ] Configurar permisos: `chmod -R 755 storage/ bootstrap/cache/`
- [ ] Instalar dependencias: `composer install --no-dev --optimize-autoloader`

## **Configuración Laravel:**
- [ ] Generar clave: `php artisan key:generate --force`
- [ ] Ejecutar migraciones: `php artisan migrate --force`
- [ ] Crear usuarios: `php artisan db:seed --class=UserSeeder --force`
- [ ] Optimizar: `php artisan config:cache route:cache view:cache`
- [ ] Enlace storage: `php artisan storage:link`

## **Configuración servidor web:**
- [ ] Agregar configuración Apache (apache-config.txt)
- [ ] Configurar SSL/HTTPS
- [ ] Configurar headers de seguridad
- [ ] Configurar CORS si es necesario

## **Verificación final:**
- [ ] Acceso a dominio principal: `https://tu-dominio.com`
- [ ] Test API login: `curl -X POST https://tu-dominio.com/api/login ...`
- [ ] Verificar logs sin errores: `storage/logs/laravel.log`
- [ ] Test todas las rutas principales

## **Opcional - Configuración avanzada:**
- [ ] Configurar Cron para Laravel Scheduler
- [ ] Configurar Queue Workers
- [ ] Configurar Redis/Memcached si disponible
- [ ] Configurar backup automático de BD
- [ ] Configurar monitoreo de errores

## **URLs importantes después del deploy:**
- **API Base:** `https://tu-dominio.com/api/`
- **Login:** `https://tu-dominio.com/api/login`
- **Registro:** `https://tu-dominio.com/api/register`
- **User Profile:** `https://tu-dominio.com/api/user` (requiere token)

## **Credenciales de prueba:**
- **Admin:** admin@ejemplo.com / 12345678
- **Empleado:** empleado@ejemplo.com / 12345678
- **Guest:** guest@ejemplo.com / 12345678
