# Script de pruebas para la API de Laravel

Este archivo contiene ejemplos de cómo probar tu API backend de Laravel usando diferentes herramientas.

## 1. Iniciar el servidor de desarrollo

```powershell
php artisan serve
```

El servidor estará disponible en: http://localhost:8000

## 2. Probar con cURL (Windows PowerShell)

### Registro de usuario
```powershell
curl -X POST http://localhost:8000/api/register `
  -H "Content-Type: application/json" `
  -H "Accept: application/json" `
  -d '{"name":"Juan Perez","email":"juan@example.com","password":"12345678","password_confirmation":"12345678","role":"empleado"}'
```

### Login
```powershell
curl -X POST http://localhost:8000/api/login `
  -H "Content-Type: application/json" `
  -H "Accept: application/json" `
  -d '{"email":"juan@example.com","password":"12345678"}'
```

### Obtener perfil de usuario (necesita token)
```powershell
curl -X GET http://localhost:8000/api/user `
  -H "Content-Type: application/json" `
  -H "Accept: application/json" `
  -H "Authorization: Bearer TU_TOKEN_AQUI"
```

### Probar ruta de empleado
```powershell
curl -X GET http://localhost:8000/api/empleado/marcar `
  -H "Content-Type: application/json" `
  -H "Accept: application/json" `
  -H "Authorization: Bearer TU_TOKEN_AQUI"
```

### Logout
```powershell
curl -X POST http://localhost:8000/api/logout `
  -H "Content-Type: application/json" `
  -H "Accept: application/json" `
  -H "Authorization: Bearer TU_TOKEN_AQUI"
```

## 3. Usando Postman o Insomnia

1. Importa la colección desde `collections/bruno.json` si usas Bruno
2. O crea manualmente las siguientes peticiones:

### Configuración base:
- Base URL: `http://localhost:8000/api`
- Headers para todas las peticiones:
  - `Content-Type: application/json`
  - `Accept: application/json`

### Peticiones a crear:

1. **POST** `/register`
2. **POST** `/login`
3. **GET** `/user` (con Authorization Bearer Token)
4. **POST** `/logout` (con Authorization Bearer Token)
5. **GET** `/empleado/marcar` (con Authorization Bearer Token)
6. **GET** `/admin/panel` (con Authorization Bearer Token)

## 4. Usando PHPUnit (Tests automatizados)

```powershell
php artisan test
```

## 5. Verificar la base de datos

```powershell
php artisan tinker
```

Luego en Tinker:
```php
App\Models\User::all();
App\Models\User::where('role', 'empleado')->get();
```
