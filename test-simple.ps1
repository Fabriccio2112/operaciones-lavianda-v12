# Script simple para probar la API
Write-Host "🚀 Probando la API de Laravel..." -ForegroundColor Green

# Test de login
try {
    $headers = @{
        'Content-Type' = 'application/json'
        'Accept' = 'application/json'
    }
    
    $body = @{
        email = "admin@ejemplo.com"
        password = "12345678"
    } | ConvertTo-Json
    
    Write-Host "1. Probando login..." -ForegroundColor Yellow
    $response = Invoke-RestMethod -Uri "http://localhost:8000/api/login" -Method POST -Headers $headers -Body $body
    
    Write-Host "✅ Login exitoso!" -ForegroundColor Green
    Write-Host "Token: $($response.access_token.Substring(0,20))..." -ForegroundColor Cyan
    
    # Guardar token para otras pruebas
    $token = $response.access_token
    $authHeaders = @{
        'Content-Type' = 'application/json'
        'Accept' = 'application/json'
        'Authorization' = "Bearer $token"
    }
    
    # Test de perfil
    Write-Host "`n2. Probando obtener perfil..." -ForegroundColor Yellow
    $userProfile = Invoke-RestMethod -Uri "http://localhost:8000/api/user" -Method GET -Headers $authHeaders
    Write-Host "✅ Perfil obtenido: $($userProfile.name) ($($userProfile.role))" -ForegroundColor Green
    
    # Test de ruta de admin
    Write-Host "`n3. Probando ruta de admin..." -ForegroundColor Yellow
    $admin = Invoke-RestMethod -Uri "http://localhost:8000/api/admin/panel" -Method GET -Headers $authHeaders
    Write-Host "✅ $($admin.message)" -ForegroundColor Green
    
} catch {
    Write-Host "❌ Error: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n🎉 Pruebas completadas!" -ForegroundColor Green
