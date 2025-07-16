# Prueba de rutas protegidas
Write-Host "Probando rutas protegidas..." -ForegroundColor Yellow

# Leer token del archivo
if (Test-Path "token.txt") {
    $token = Get-Content "token.txt" -Raw
    $token = $token.Trim()
    
    $headers = @{
        'Authorization' = "Bearer $token"
        'Accept' = 'application/json'
    }
    
    Write-Host "Usando token: $($token.Substring(0,30))..." -ForegroundColor Gray
    
    # Test 1: Perfil de usuario
    try {
        Write-Host "`n1. Probando /api/user..." -ForegroundColor Cyan
        $user = Invoke-RestMethod -Uri "http://localhost:8000/api/user" -Method GET -Headers $headers
        Write-Host "✅ Perfil obtenido: $($user.name) ($($user.role))" -ForegroundColor Green
    } catch {
        Write-Host "❌ Error obteniendo perfil: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    # Test 2: Ruta de admin
    try {
        Write-Host "`n2. Probando /api/admin/panel..." -ForegroundColor Cyan
        $admin = Invoke-RestMethod -Uri "http://localhost:8000/api/admin/panel" -Method GET -Headers $headers
        Write-Host "✅ $($admin.message)" -ForegroundColor Green
    } catch {
        Write-Host "❌ Error en ruta admin: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    # Test 3: Ruta de empleado
    try {
        Write-Host "`n3. Probando /api/empleado/marcar..." -ForegroundColor Cyan
        $empleado = Invoke-RestMethod -Uri "http://localhost:8000/api/empleado/marcar" -Method GET -Headers $headers
        Write-Host "✅ $($empleado.message)" -ForegroundColor Green
    } catch {
        Write-Host "❌ Error en ruta empleado: $($_.Exception.Message)" -ForegroundColor Red
    }
    
} else {
    Write-Host "❌ No se encontró token.txt. Ejecuta primero test-login.ps1" -ForegroundColor Red
}
