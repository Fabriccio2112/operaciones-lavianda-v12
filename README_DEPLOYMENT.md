# 🚀 RESUMEN: Subir Laravel API a Plesk

## 📂 **Archivos creados para el deployment:**

1. **PLESK_DEPLOYMENT_GUIDE.md** - Guía completa paso a paso
2. **DEPLOYMENT_CHECKLIST.md** - Lista de verificación
3. **.env.production** - Plantilla de configuración para producción
4. **install.sh** - Script de instalación para el servidor
5. **apache-config.txt** - Configuración de Apache para Plesk
6. **prepare-production.ps1** - Script de preparación local

## ⚡ **Pasos rápidos:**

### **1. Preparar en local:**
```powershell
.\prepare-production.ps1
```

### **2. En Plesk:**
1. **Crear base de datos** (MySQL)
2. **Configurar dominio** con Document Root: `/public`
3. **Subir archivos** (excepto .env, node_modules, logs)
4. **Crear .env** con datos reales del servidor
5. **Ejecutar install.sh** o comandos manuales

### **3. Comandos en servidor:**
```bash
composer install --no-dev --optimize-autoloader
php artisan key:generate --force
php artisan migrate --force
php artisan db:seed --class=UserSeeder --force
php artisan config:cache
chmod -R 755 storage/ bootstrap/cache/
```

## 🌐 **URLs finales:**
- **API:** `https://tu-dominio.com/api/`
- **Login:** `https://tu-dominio.com/api/login`
- **Test:** `https://tu-dominio.com/api/user` (con token)

## 👥 **Usuarios de prueba:**
- **admin@ejemplo.com / 12345678** (rol: admin)
- **empleado@ejemplo.com / 12345678** (rol: empleado)

## 🧪 **Test rápido:**
```bash
curl -X POST https://tu-dominio.com/api/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@ejemplo.com","password":"12345678"}'
```

---

**¡Tu API Laravel estará lista para usar en producción!** 🎉

**Archivos importantes:**
- Leer **PLESK_DEPLOYMENT_GUIDE.md** para guía detallada
- Usar **DEPLOYMENT_CHECKLIST.md** para verificar cada paso
- Configurar **.env.production** con tus datos reales
