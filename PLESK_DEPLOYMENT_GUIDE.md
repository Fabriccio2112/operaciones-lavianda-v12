# 🌐 Guía Completa: Subir Laravel a Plesk

## 📋 **Requisitos del Servidor Plesk**
- PHP 8.2 o superior
- MySQL/MariaDB
- Composer (instalado en el servidor)
- Extensión PHP: OpenSSL, PDO, Mbstring, Tokenizer, XML, Ctype, JSON

**Paso a Paso**

### **1. Preparar archivos en local**

```powershell
# Ejecutar en tu proyecto local
.\prepare-production.ps1
```

### **2. Crear base de datos en Plesk**

1. **Accede a Plesk** → Bases de datos
2. **Crear nueva base de datos:**
   - Nombre: `tu_proyecto_db`
   - Usuario: `tu_usuario`
   - Contraseña: (genera una segura)
3. **Anota los datos** para el archivo .env

### **3. Configurar dominio en Plesk**

1. **Ir a Dominios** → Tu dominio
2. **Configuración de hosting:**
   - Raíz del documento: `/public` (⚠️ MUY IMPORTANTE)
   - Versión PHP: 8.2+
   - Módulos PHP necesarios activados

### **4. Subir archivos**

#### **Opción A: FTP/SFTP**
```
Subir TODO excepto:
❌ .env (crear nuevo en servidor)
❌ node_modules/
❌ storage/logs/*.log
❌ vendor/ (si instalarás con Composer en servidor)
```

#### **Opción B: Archivo ZIP**
1. Comprimir proyecto (excepto archivos listados arriba)
2. Subir via File Manager de Plesk
3. Extraer en la raíz del dominio

### **5. Configurar permisos en Plesk**

**File Manager → Permisos:**
```bash
storage/ → 755 (recursivo)
bootstrap/cache/ → 755 (recursivo)
```

### **6. Configurar .env en el servidor**

1. **Crear archivo .env** en la raíz del proyecto
2. **Copiar contenido** de `.env.production`
3. **Actualizar datos:**
   ```env
   APP_URL=https://tu-dominio.com
   DB_HOST=localhost
   DB_DATABASE=tu_nombre_bd_real
   DB_USERNAME=tu_usuario_real
   DB_PASSWORD=tu_password_real
   ```

### **7. Instalar dependencias (en servidor)**

**Terminal SSH o Scheduled Tasks:**
```bash
cd /var/www/vhosts/tu-dominio.com/httpdocs
composer install --no-dev --optimize-autoloader
```

### **8. Configurar Laravel**

**Ejecutar comandos en orden:**
```bash
# Generar clave de aplicación
php artisan key:generate

# Ejecutar migraciones
php artisan migrate --force

# Crear usuarios de prueba
php artisan db:seed --class=UserSeeder --force

# Optimizar para producción
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Crear enlace simbólico para storage
php artisan storage:link
```

### **9. Configurar Cron Jobs (para queues)**

**Plesk → Scheduled Tasks:**
```bash
Comando: cd /var/www/vhosts/tu-dominio.com/httpdocs && php artisan schedule:run >> /dev/null 2>&1
Frecuencia: Cada minuto
```

### **10. Configurar HTTPS**

1. **SSL/TLS Certificates** en Plesk
2. **Let's Encrypt** (gratis) o certificado personalizado
3. **Forzar HTTPS** en configuración del dominio

### **11. Configurar headers de seguridad**

**Apache & nginx → Additional directives:**
```apache
# Para Apache
Header always set X-Content-Type-Options nosniff
Header always set X-Frame-Options DENY
Header always set X-XSS-Protection "1; mode=block"
Header always set Strict-Transport-Security "max-age=31536000; includeSubDomains"
```

## 🧪 **Verificar instalación**

### **URLs a probar:**
- `https://tu-dominio.com/` → Página de inicio Laravel
- `https://tu-dominio.com/api/login` → Endpoint de API

### **Test con cURL:**
```bash
curl -X POST https://tu-dominio.com/api/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@ejemplo.com","password":"12345678"}'
```

## 🔧 **Solución de problemas comunes**

### **Error 500:**
1. Verificar logs en `storage/logs/laravel.log`
2. Verificar permisos de `storage/` y `bootstrap/cache/`
3. Verificar que `.env` tenga `APP_KEY` generada

### **Error de base de datos:**
1. Verificar credenciales en `.env`
2. Verificar que la BD existe en Plesk
3. Verificar que el usuario tiene permisos

### **Error de permisos:**
```bash
chmod -R 755 storage/
chmod -R 755 bootstrap/cache/
```

### **Error de Composer:**
1. Verificar que Composer esté instalado
2. Usar ruta completa: `/usr/local/bin/composer`

## 📱 **Configuración adicional para API**

### **CORS (si necesitas frontend separado):**
```php
// config/cors.php
'paths' => ['api/*'],
'allowed_methods' => ['*'],
'allowed_origins' => ['https://tu-frontend.com'],
'allowed_headers' => ['*'],
```

### **Rate limiting:**
```php
// routes/api.php
Route::middleware(['throttle:60,1'])->group(function () {
    // Tus rutas
});
```

## 🎉 **¡Listo!**

Tu API Laravel debería estar funcionando en:
- **API Base:** `https://tu-dominio.com/api/`
- **Login:** `https://tu-dominio.com/api/login`
- **Registro:** `https://tu-dominio.com/api/register`

### **Credenciales de prueba:**
- **Admin:** admin@ejemplo.com / 12345678
- **Empleado:** empleado@ejemplo.com / 12345678
