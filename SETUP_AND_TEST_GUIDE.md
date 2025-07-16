# 🚀 Guía Completa para Probar el Backend Laravel

## 📋 Pasos para Configurar y Probar

### 1. Configuración Inicial

```powershell
# 1. Instalar dependencias
composer install

# 2. Configurar la base de datos
php artisan migrate

# 3. Crear usuarios de prueba
php artisan db:seed --class=UserSeeder

# 4. Iniciar el servidor
php artisan serve
```

### 2. Usuarios de Prueba Creados

| Email | Contraseña | Rol |
|-------|------------|-----|
| admin@ejemplo.com | 12345678 | admin |
| root@ejemplo.com | 12345678 | root |
| empleado@ejemplo.com | 12345678 | empleado |
| guest@ejemplo.com | 12345678 | guest |

### 3. Endpoints Disponibles

#### 🔓 Rutas Públicas (sin autenticación)
- `POST /api/register` - Registrar usuario
- `POST /api/login` - Iniciar sesión
- `POST /api/forgot-password` - Solicitar reseteo de contraseña
- `POST /api/reset-password` - Resetear contraseña

#### 🔒 Rutas Protegidas (requieren token)
- `GET /api/user` - Obtener perfil del usuario
- `POST /api/logout` - Cerrar sesión

#### 👥 Rutas por Rol
- `GET /api/admin/panel` - Solo para admin
- `GET /api/super/panel` - Para admin y root
- `GET /api/empleado/marcar` - Solo para empleado

### 4. Métodos de Prueba

#### A) 🧪 Tests Automatizados (Recomendado)
```powershell
# Ejecutar todos los tests
php artisan test

# Ejecutar solo tests de autenticación
php artisan test --filter ApiAuthTest
```

#### B) 🔧 Script PowerShell Automatizado
```powershell
# Ejecutar el script de pruebas
.\test-api.ps1
```

#### C) 📱 Herramientas Manuales

**Postman/Insomnia:**
1. Importa la colección desde `collections/bruno.json`
2. Configura la base URL: `http://localhost:8000/api`

**cURL (Ejemplos):**

1. **Login:**
```powershell
curl -X POST http://localhost:8000/api/login `
  -H "Content-Type: application/json" `
  -d '{"email":"admin@ejemplo.com","password":"12345678"}'
```

2. **Acceder a perfil (reemplaza TOKEN):**
```powershell
curl -X GET http://localhost:8000/api/user `
  -H "Authorization: Bearer TOKEN_AQUI"
```

3. **Probar ruta de admin:**
```powershell
curl -X GET http://localhost:8000/api/admin/panel `
  -H "Authorization: Bearer TOKEN_AQUI"
```

### 5. Verificación en Base de Datos

```powershell
# Abrir Tinker
php artisan tinker

# Ver todos los usuarios
App\Models\User::all();

# Ver tokens activos
DB::table('personal_access_tokens')->get();
```

### 6. ✅ Checklist de Pruebas

- [ ] ✅ Registro de usuario funciona
- [ ] ✅ Login genera token válido
- [ ] ✅ Rutas protegidas requieren autenticación
- [ ] ✅ Middleware de roles funciona correctamente
- [ ] ✅ Admin puede acceder a `/admin/panel`
- [ ] ✅ Empleado puede acceder a `/empleado/marcar`
- [ ] ✅ Empleado NO puede acceder a `/admin/panel`
- [ ] ✅ Logout invalida el token
- [ ] ✅ Rutas sin token devuelven 401

### 7. 🐛 Solución de Problemas

**Error 401 (Unauthorized):**
- Verifica que el token esté en el header: `Authorization: Bearer TOKEN`
- Asegúrate de que el token no haya expirado

**Error 403 (Forbidden):**
- Verifica que el usuario tenga el rol correcto
- Confirma que el middleware de roles esté configurado

**Error 500:**
- Revisa los logs: `storage/logs/laravel.log`
- Verifica la configuración de la base de datos

### 8. 📁 Archivos Importantes

- `routes/api.php` - Definición de rutas
- `app/Http/Controllers/Api/AuthController.php` - Controlador de autenticación
- `app/Http/Middleware/RoleMiddleware.php` - Middleware de roles
- `tests/Feature/ApiAuthTest.php` - Tests automatizados
- `database/seeders/UserSeeder.php` - Usuarios de prueba

### 9. 🔧 Comandos Útiles

```powershell
# Reiniciar base de datos y seeders
php artisan migrate:fresh --seed

# Ver rutas disponibles
php artisan route:list

# Limpiar caché
php artisan cache:clear
php artisan config:clear

# Generar clave de aplicación (si es necesario)
php artisan key:generate
```

¡Tu backend Laravel está listo para ser probado! 🎉
