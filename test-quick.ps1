# Test rápido de funcionalidad principal
Write-Host "=== TEST RÁPIDO DE API ===" -ForegroundColor Cyan

# Test básico de login
Write-Host "1. Probando login..." -ForegroundColor Yellow
$loginData = @{
    email = "admin@lavianda.com"
    password = "password123"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "http://localhost:8000/api/login" -Method Post -Body $loginData -ContentType "application/json"
    $token = $response.access_token
    Write-Host "✅ Login exitoso: $($response.user.name) ($($response.user.role))" -ForegroundColor Green
    Write-Host "Token: $($token.Substring(0, 20))..." -ForegroundColor Gray
    
    # Test de perfil
    Write-Host "`n2. Probando perfil..." -ForegroundColor Yellow
    $headers = @{
        Authorization = "Bearer $token"
        "Content-Type" = "application/json"
    }
    $profileResponse = Invoke-RestMethod -Uri "http://localhost:8000/api/user" -Method Get -Headers $headers
    Write-Host "✅ Perfil obtenido: $($profileResponse.name)" -ForegroundColor Green
    
    # Test de panel admin
    Write-Host "`n3. Probando panel admin..." -ForegroundColor Yellow
    $adminResponse = Invoke-RestMethod -Uri "http://localhost:8000/api/admin/panel" -Method Get -Headers $headers
    Write-Host "✅ Panel admin: $($adminResponse.message)" -ForegroundColor Green
    
    Write-Host "`n🎉 API funcionando correctamente!" -ForegroundColor Green
    
} catch {
    Write-Host "❌ Error: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.Response) {
        Write-Host "Status: $($_.Exception.Response.StatusCode)" -ForegroundColor Red
    }
}
