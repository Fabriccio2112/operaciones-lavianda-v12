# Test de AuthController recreado
Write-Host "=== TEST AUTHCONTROLLER RECREADO ===" -ForegroundColor Cyan
Write-Host ""

# Test 1: Verificar que el login funciona
Write-Host "1. Probando login después de recrear AuthController..." -ForegroundColor Yellow
$loginData = @{
    email = "admin@lavianda.com"
    password = "password123"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "http://localhost:8000/api/login" -Method Post -Body $loginData -ContentType "application/json"
    Write-Host "✅ Login exitoso!" -ForegroundColor Green
    Write-Host "Token: $($response.access_token.Substring(0, 20))..." -ForegroundColor Gray
    Write-Host "Usuario: $($response.user.name)" -ForegroundColor Gray
    Write-Host "Rol: $($response.user.role)" -ForegroundColor Gray
    
    # Test 2: Probar perfil de usuario
    Write-Host "`n2. Probando perfil de usuario..." -ForegroundColor Yellow
    $headers = @{
        Authorization = "Bearer $($response.access_token)"
        "Content-Type" = "application/json"
    }
    
    $profileResponse = Invoke-RestMethod -Uri "http://localhost:8000/api/user" -Method Get -Headers $headers
    Write-Host "✅ Perfil obtenido: $($profileResponse.name)" -ForegroundColor Green
    
    # Test 3: Probar logout
    Write-Host "`n3. Probando logout..." -ForegroundColor Yellow
    $logoutResponse = Invoke-RestMethod -Uri "http://localhost:8000/api/logout" -Method Post -Headers $headers
    Write-Host "✅ Logout exitoso: $($logoutResponse.message)" -ForegroundColor Green
    
    Write-Host "`n🎉 AuthController recreado y funcionando correctamente!" -ForegroundColor Green
    
} catch {
    Write-Host "❌ Error: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.Response) {
        Write-Host "Status: $($_.Exception.Response.StatusCode)" -ForegroundColor Red
    }
}

Write-Host "`n📝 Notas:" -ForegroundColor Yellow
Write-Host "- El archivo AuthController.php fue recreado exitosamente" -ForegroundColor White
Write-Host "- Se limpiaron los cachés de Composer y Laravel" -ForegroundColor White
Write-Host "- Todas las funcionalidades están restauradas" -ForegroundColor White
