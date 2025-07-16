# 🚨 SOLUCIÓN AL ERROR 422: "The selected role is invalid"

## ❌ **Problema:**
Cuando intentas registrar un usuario con rol "admin", obtienes error 422:
```json
{
  "message": "The selected role is invalid.",
  "errors": {
    "role": ["The selected role is invalid."]
  }
}
```

## ✅ **Solución aplicada:**

### **1. Se corrigió la validación en AuthController:**
```php
// ANTES (solo permitía guest y empleado):
'role' => ['sometimes', 'string', Rule::in(['guest', 'empleado'])],

// AHORA (permite todos los roles):
'role' => ['sometimes', 'string', Rule::in(['guest', 'empleado', 'admin', 'root'])],
```

### **2. Reinicia el servidor:**
```powershell
# Cerrar servidor actual
Ctrl+C en la terminal del servidor

# Reiniciar
php artisan serve
```

## 🎯 **Roles disponibles ahora:**
- **`guest`** - Usuario invitado (por defecto)
- **`empleado`** - Empleado 
- **`admin`** - Administrador
- **`root`** - Super administrador

## 📝 **Ejemplos de JSON válidos:**

### **Registrar Admin:**
```json
{
  "name": "Fabriccio Mora",
  "email": "elcapofabri21@gmail.com", 
  "password": "Theylor$21",
  "password_confirmation": "Theylor$21",
  "role": "admin"
}
```

### **Registrar Empleado:**
```json
{
  "name": "Juan Pérez",
  "email": "juan@ejemplo.com",
  "password": "12345678", 
  "password_confirmation": "12345678",
  "role": "empleado"
}
```

### **Registrar Guest (sin especificar rol):**
```json
{
  "name": "Usuario Normal",
  "email": "usuario@ejemplo.com",
  "password": "12345678",
  "password_confirmation": "12345678"
}
```

## 🔧 **Si el error persiste:**

1. **Verifica que el servidor esté reiniciado**
2. **Prueba con el endpoint de login primero:**
   ```json
   POST /api/login
   {
     "email": "admin@ejemplo.com",
     "password": "12345678"
   }
   ```
3. **Revisa los logs:** `storage/logs/laravel.log`

## ✅ **Ahora tu registro debería funcionar correctamente!**

---

# 🚨 SOLUCIÓN AL ERROR: "Table 'personal_access_tokens' doesn't exist"

## ❌ **Problema:**
Cuando intentas hacer login, obtienes error SQLSTATE[42S02]:
```json
{
  "message": "SQLSTATE[42S02]: Base table or view not found: 1146 Table 'operaciones_lavianda_v12.personal_access_tokens' doesn't exist"
}
```

## ✅ **Solución:**

### **1. Ejecutar migraciones:**
```bash
php artisan migrate
```

### **2. Verificar estado de migraciones:**
```bash
php artisan migrate:status
```

Deberías ver que `personal_access_tokens` aparece como `[X] Ran`.

### **3. Si aún no funciona, publicar migraciones de Sanctum:**
```bash
php artisan vendor:publish --provider="Laravel\Sanctum\SanctumServiceProvider"
php artisan migrate
```

### **4. Limpiar cachés:**
```bash
php artisan config:clear
php artisan cache:clear
php artisan route:clear
```

## 🎯 **Verificación:**
Una vez ejecutadas las migraciones, deberías poder hacer login exitosamente:

```json
POST /api/login
{
  "email": "admin@lavianda.com",
  "password": "password123"
}
```

**Respuesta esperada:**
```json
{
  "access_token": "2|3UdIwl9LNrdPbZbY60LK2tPzGj3H...",
  "token_type": "Bearer",
  "user": {
    "id": 2,
    "name": "Administrador",
    "email": "admin@lavianda.com",
    "role": "admin"
  }
}
```

## ✅ **Status actual:** RESUELTO ✅
- Tabla `personal_access_tokens` creada correctamente
- Login funciona y genera tokens
- Rutas protegidas funcionan con tokens
