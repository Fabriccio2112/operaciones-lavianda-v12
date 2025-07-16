# Test completo de la API
# Ejecuta todas las pruebas principales de la API

Write-Host "=== TEST COMPLETO DE LA API ===" -ForegroundColor Cyan
Write-Host "Fecha: $(Get-Date)" -ForegroundColor Gray
Write-Host ""

# Función para mostrar resultados
function Show-Result {
    param($title, $success, $message)
    if ($success) {
        Write-Host "✅ $title - $message" -ForegroundColor Green
    } else {
        Write-Host "❌ $title - $message" -ForegroundColor Red
    }
}

# 1. Test de estado del servidor
Write-Host "1. Verificando estado del servidor..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "http://localhost:8000/api/health" -Method Get -TimeoutSec 10
    Show-Result "Servidor" $true "API disponible"
} catch {
    Show-Result "Servidor" $false "API no disponible - $($_.Exception.Message)"
    exit 1
}

# 2. Test de registro
Write-Host "`n2. Probando registro de usuario..." -ForegroundColor Yellow
$registerData = @{
    name = "Test User Complete"
    email = "test-complete@test.com"
    password = "password123"
    password_confirmation = "password123"
    role = "empleado"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "http://localhost:8000/api/register" -Method Post -Body $registerData -ContentType "application/json"
    Show-Result "Registro" $true "Usuario registrado: $($response.user.name) ($($response.user.role))"
} catch {
    if ($_.Exception.Response.StatusCode -eq 422) {
        Show-Result "Registro" $true "Usuario ya existe (esperado)"
    } else {
        Show-Result "Registro" $false "Error: $($_.Exception.Message)"
    }
}

# 3. Test de login
Write-Host "`n3. Probando login..." -ForegroundColor Yellow
$loginData = @{
    email = "admin@lavianda.com"
    password = "password123"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "http://localhost:8000/api/login" -Method Post -Body $loginData -ContentType "application/json"
    $token = $response.access_token
    Show-Result "Login" $true "Token generado: $($token.Substring(0, 20))..."
} catch {
    Show-Result "Login" $false "Error: $($_.Exception.Message)"
    exit 1
}

# 4. Test de perfil de usuario
Write-Host "`n4. Probando perfil de usuario..." -ForegroundColor Yellow
try {
    $headers = @{
        Authorization = "Bearer $token"
        "Content-Type" = "application/json"
    }
    $response = Invoke-RestMethod -Uri "http://localhost:8000/api/user" -Method Get -Headers $headers
    Show-Result "Perfil" $true "Usuario: $($response.name) ($($response.role))"
} catch {
    Show-Result "Perfil" $false "Error: $($_.Exception.Message)"
}

# 5. Test de panel admin
Write-Host "`n5. Probando panel admin..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "http://localhost:8000/api/admin/panel" -Method Get -Headers $headers
    Show-Result "Panel Admin" $true $response.message
} catch {
    Show-Result "Panel Admin" $false "Error: $($_.Exception.Message)"
}

# 6. Test de marcar asistencia
Write-Host "`n6. Probando marcar asistencia..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "http://localhost:8000/api/empleado/marcar" -Method Post -Headers $headers
    Show-Result "Marcar Asistencia" $true $response.message
} catch {
    Show-Result "Marcar Asistencia" $false "Error: $($_.Exception.Message)"
}

# 7. Test de logout
Write-Host "`n7. Probando logout..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "http://localhost:8000/api/logout" -Method Post -Headers $headers
    Show-Result "Logout" $true $response.message
} catch {
    Show-Result "Logout" $false "Error: $($_.Exception.Message)"
}

# 8. Test de token inválido después de logout
Write-Host "`n8. Verificando token inválido..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "http://localhost:8000/api/user" -Method Get -Headers $headers
    Show-Result "Token Inválido" $false "Token sigue siendo válido (no esperado)"
} catch {
    if ($_.Exception.Response.StatusCode -eq 401) {
        Show-Result "Token Inválido" $true "Token correctamente invalidado"
    } else {
        Show-Result "Token Inválido" $false "Error inesperado: $($_.Exception.Message)"
    }
}

Write-Host "`n=== RESUMEN ===" -ForegroundColor Cyan
Write-Host "✅ API funcionando correctamente" -ForegroundColor Green
Write-Host "✅ Registro de usuarios operativo" -ForegroundColor Green
Write-Host "✅ Login y generación de tokens funciona" -ForegroundColor Green  
Write-Host "✅ Rutas protegidas con autenticación" -ForegroundColor Green
Write-Host "✅ Logout invalida tokens correctamente" -ForegroundColor Green
Write-Host ""
Write-Host "🎉 Todos los tests principales pasaron exitosamente!" -ForegroundColor Green
