# Prueba de login
Write-Host "Probando login..." -ForegroundColor Yellow

$body = @{
    email = "admin@ejemplo.com"
    password = "12345678"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "http://localhost:8000/api/login" -Method POST -ContentType "application/json" -Body $body
    Write-Host "✅ Login exitoso!" -ForegroundColor Green
    Write-Host "Token: $($response.access_token.Substring(0,30))..." -ForegroundColor Cyan
    Write-Host "Usuario: $($response.user.name)" -ForegroundColor Cyan
    Write-Host "Rol: $($response.user.role)" -ForegroundColor Cyan
    
    # Guardar token para prueba siguiente
    $response.access_token | Out-File -FilePath "token.txt" -Encoding UTF8
    Write-Host "Token guardado en token.txt" -ForegroundColor Green
    
} catch {
    Write-Host "❌ Error en login: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.Response) {
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        $errorBody = $reader.ReadToEnd()
        Write-Host "Detalles: $errorBody" -ForegroundColor Red
    }
}
