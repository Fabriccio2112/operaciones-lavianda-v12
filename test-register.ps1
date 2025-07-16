# Prueba básica de registro
Write-Host "Probando registro..." -ForegroundColor Yellow

$body = @{
    name = "Test User"
    email = "test@test.com"
    password = "12345678"
    password_confirmation = "12345678"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "http://localhost:8000/api/register" -Method POST -ContentType "application/json" -Body $body
    Write-Host "✅ Registro exitoso!" -ForegroundColor Green
    Write-Host "Usuario: $($response.user.name)" -ForegroundColor Cyan
    Write-Host "Email: $($response.user.email)" -ForegroundColor Cyan
    Write-Host "Rol: $($response.user.role)" -ForegroundColor Cyan
} catch {
    Write-Host "❌ Error en registro: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.Response) {
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        $errorBody = $reader.ReadToEnd()
        Write-Host "Detalles: $errorBody" -ForegroundColor Red
    }
}
