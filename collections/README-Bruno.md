# 🧪 Colección Bruno - API Laravel

## 📋 **Qué incluye esta colección:**

### **Endpoints disponibles:**
1. **Registro de Usuario** - `POST /api/register`
2. **Login Admin** - `POST /api/login` 
3. **Login Empleado** - `POST /api/login`
4. **Obtener Perfil** - `GET /api/user` (requiere auth)
5. **Panel Admin** - `GET /api/admin/panel` (solo admin)
6. **Marcar Asistencia** - `GET /api/empleado/marcar` (solo empleado)
7. **Panel Super** - `GET /api/super/panel` (admin y root)
8. **Test Sin Auth** - `GET /api/user` (sin token - debe fallar)
9. **Test Permisos** - Empleado intentando acceder a admin (debe fallar)
10. **Logout** - `POST /api/logout`

## 🚀 **Cómo usar:**

### **1. Abrir en Bruno:**
- Abrir Bruno
- File → Import Collection
- Seleccionar la carpeta `collections/`

### **2. Configurar entorno:**
- **Local:** `http://localhost:8000` (para desarrollo)
- **Production:** `https://tu-dominio.com` (para servidor)

### **3. Ejecutar en orden:**
1. **Primero:** Login Admin (guarda el token)
2. **Luego:** Login Empleado (guarda otro token)
3. **Después:** Cualquier endpoint protegido

## 🔑 **Tokens automáticos:**
- Los logins guardan automáticamente los tokens
- `{{authToken}}` - Token del admin
- `{{empleadoToken}}` - Token del empleado
- Se usan automáticamente en las peticiones

## 👥 **Credenciales incluidas:**

### **Usuarios de prueba:**
```json
{
  "admin": {
    "email": "admin@ejemplo.com",
    "password": "12345678",
    "role": "admin"
  },
  "empleado": {
    "email": "empleado@ejemplo.com", 
    "password": "12345678",
    "role": "empleado"
  },
  "guest": {
    "email": "guest@ejemplo.com",
    "password": "12345678",
    "role": "guest"
  }
}
```

### **Roles disponibles para registro:**
- **`guest`** - Usuario invitado (rol por defecto)
- **`empleado`** - Empleado de la empresa
- **`admin`** - Administrador
- **`root`** - Super administrador

## 🔧 **Solución de problemas comunes:**

### **Error: "Table 'personal_access_tokens' doesn't exist"**
Si obtienes este error al hacer login, ejecuta estos comandos en orden:

```bash
# 1. Limpiar caché
php artisan config:clear
php artisan cache:clear
php artisan view:clear

# 2. Verificar migraciones
php artisan migrate:status

# 3. Si falta la migración, ejecutar:
php artisan migrate

# 4. Reiniciar servidor
taskkill /f /im php.exe
php artisan serve
```

### **Verificar que las migraciones están completas:**
```bash
php artisan migrate:status
```
Deberías ver `personal_access_tokens` marcado como "Ran".

### **Si el problema persiste:**
1. **Limpiar todo el caché:**
   ```bash
   php artisan config:clear
   php artisan cache:clear
   php artisan view:clear
   ```

2. **Verificar la tabla en la base de datos:**
   ```bash
   php artisan tinker
   DB::select("SHOW TABLES LIKE 'personal_access_tokens'")
   exit
   ```

3. **Reiniciar completamente el servidor:**
   ```bash
   taskkill /f /im php.exe
   php artisan serve
   ```

### **Crear usuarios de prueba:**
```bash
php artisan db:seed --class=UserSeeder
```

## ✅ **Tests automáticos:**
Cada petición incluye tests que verifican:
- Códigos de estado HTTP correctos
- Estructura de respuesta esperada
- Contenido de mensajes
- Validación de roles y permisos

## 🔄 **Flujo de pruebas recomendado:**

1. **Login Admin** → Guarda token admin
2. **Perfil Usuario** → Usa token admin
3. **Panel Admin** → Debe funcionar (admin tiene permisos)
4. **Login Empleado** → Guarda token empleado  
5. **Marcar Asistencia** → Usa token empleado
6. **Test Empleado→Admin** → Debe fallar (403)
7. **Test Sin Auth** → Debe fallar (401)
8. **Logout** → Invalida token

## 🌐 **Cambiar entorno:**
- **Local:** Para desarrollo con `php artisan serve`
- **Production:** Para servidor en Plesk

## 📊 **Respuestas esperadas:**

### **Login exitoso:**
```json
{
  "message": "Login exitoso",
  "access_token": "1|abc123...",
  "token_type": "Bearer",
  "user": {
    "id": 1,
    "name": "Admin",
    "email": "admin@ejemplo.com",
    "role": "admin"
  }
}
```

### **Error 401:**
```json
{
  "message": "Unauthenticated."
}
```

### **Error 403:**
```json
{
  "message": "Sin permisos"
}
```

## 🔐 **Endpoints de Reseteo de Contraseña**

### **1. Solicitar reseteo de contraseña**
```
POST /api/forgot-password
```

**Body (JSON):**
```json
{
  "email": "usuario@ejemplo.com"
}
```

**Respuesta exitosa:**
```json
{
  "message": "Enlace de reseteo enviado."
}
```

### **2. Restablecer contraseña**
```
POST /api/reset-password
```

**Body (JSON):**
```json
{
  "token": "TOKEN_FROM_EMAIL",
  "email": "usuario@ejemplo.com",
  "password": "nueva_contraseña",
  "password_confirmation": "nueva_contraseña"
}
```

**Respuesta exitosa:**
```json
{
  "message": "Contraseña reseteada con éxito."
}
```

### **⚠️ Configuración necesaria:**
Para que el reseteo funcione completamente, necesitas configurar el servidor de correo en `.env`:

```env
MAIL_MAILER=smtp
MAIL_HOST=smtp.gmail.com
MAIL_PORT=587
MAIL_USERNAME=tu_email@gmail.com
MAIL_PASSWORD=tu_password
MAIL_ENCRYPTION=tls
MAIL_FROM_ADDRESS=tu_email@gmail.com
MAIL_FROM_NAME="La Vianda"
```

---

## 🎯 **¡Listo para probar tu API!**

Ejecuta las peticiones en orden y verifica que todos los tests pasen. Esto confirmará que tu API Laravel funciona correctamente.
