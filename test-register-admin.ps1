# Test rápido del registro con rol admin
$body = @{
    name = "Test Admin"
    email = "testadmin@ejemplo.com"
    password = "12345678"
    password_confirmation = "12345678"
    role = "admin"
} | ConvertTo-Json

try {
    Write-Host "Probando registro con rol admin..." -ForegroundColor Yellow
    $response = Invoke-RestMethod -Uri "http://localhost:8000/api/register" -Method POST -ContentType "application/json" -Body $body
    Write-Host "✅ SUCCESS: Usuario admin creado!" -ForegroundColor Green
    Write-Host "ID: $($response.user.id)" -ForegroundColor Cyan
    Write-Host "Email: $($response.user.email)" -ForegroundColor Cyan
    Write-Host "Rol: $($response.user.role)" -ForegroundColor Cyan
    
} catch {
    Write-Host "❌ ERROR: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.Response) {
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        $errorBody = $reader.ReadToEnd()
        Write-Host "Detalles: $errorBody" -ForegroundColor Red
    }
}
