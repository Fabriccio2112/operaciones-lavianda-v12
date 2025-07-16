# Prueba rápida de la API
$body = '{"email":"admin@ejemplo.com","password":"12345678"}'

try {
    Write-Host "Probando login..." -ForegroundColor Yellow
    $response = Invoke-RestMethod -Uri "http://localhost:8000/api/login" -Method POST -ContentType "application/json" -Body $body
    Write-Host "✅ SUCCESS: Token creado!" -ForegroundColor Green
    Write-Host "Token (primeros 40 caracteres): $($response.access_token.Substring(0,40))..." -ForegroundColor Cyan
    Write-Host "Usuario: $($response.user.name)" -ForegroundColor Cyan
    
    # Test de ruta protegida
    $headers = @{ 'Authorization' = "Bearer $($response.access_token)" }
    $userProfile = Invoke-RestMethod -Uri "http://localhost:8000/api/user" -Method GET -Headers $headers
    Write-Host "✅ SUCCESS: Perfil obtenido - $($userProfile.name)" -ForegroundColor Green
    
} catch {
    Write-Host "❌ ERROR: $($_.Exception.Message)" -ForegroundColor Red
}
