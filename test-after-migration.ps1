# Test rápido después de crear la tabla personal_access_tokens
Write-Host "Probando login con tabla de tokens creada..." -ForegroundColor Yellow

$body = @{
    email = "admin@ejemplo.com"
    password = "12345678"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "http://localhost:8000/api/login" -Method POST -ContentType "application/json" -Body $body
    Write-Host "✅ SUCCESS: Login funcionando!" -ForegroundColor Green
    Write-Host "Token (primeros 30 chars): $($response.access_token.Substring(0,30))..." -ForegroundColor Cyan
    Write-Host "Usuario: $($response.user.name)" -ForegroundColor Cyan
    Write-Host "Rol: $($response.user.role)" -ForegroundColor Cyan
    
    # Test de ruta protegida con el token
    $headers = @{ 
        'Authorization' = "Bearer $($response.access_token)"
        'Accept' = 'application/json'
    }
    
    Write-Host "`nProbando ruta protegida..." -ForegroundColor Yellow
    $userProfile = Invoke-RestMethod -Uri "http://localhost:8000/api/user" -Method GET -Headers $headers
    Write-Host "✅ SUCCESS: Perfil obtenido - $($userProfile.name)" -ForegroundColor Green
    
} catch {
    Write-Host "❌ ERROR: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.Response) {
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        $errorBody = $reader.ReadToEnd()
        Write-Host "Detalles: $errorBody" -ForegroundColor Red
    }
}
