# Test con usuario que ya tienes creado
Write-Host "Probando login con tu usuario admin..." -ForegroundColor Yellow

$body = @{
    email = "elcapofabri21@gmail.com"
    password = "Theylor$21"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "http://localhost:8000/api/login" -Method POST -ContentType "application/json" -Body $body
    Write-Host "✅ SUCCESS: Login funcionando!" -ForegroundColor Green
    Write-Host "Token (primeros 40 chars): $($response.access_token.Substring(0,40))..." -ForegroundColor Cyan
    Write-Host "Usuario: $($response.user.name)" -ForegroundColor Cyan
    Write-Host "Email: $($response.user.email)" -ForegroundColor Cyan
    Write-Host "Rol: $($response.user.role)" -ForegroundColor Cyan
    
    # Guardar token para otras pruebas
    $response.access_token | Out-File -FilePath "token-fabriccio.txt" -Encoding UTF8
    Write-Host "Token guardado en token-fabriccio.txt" -ForegroundColor Green
    
} catch {
    Write-Host "❌ ERROR: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.Response) {
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        $errorBody = $reader.ReadToEnd()
        Write-Host "Detalles: $errorBody" -ForegroundColor Red
    }
}
