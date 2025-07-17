# Test de funcionalidad de reseteo de contraseña
Write-Host "=== TEST DE RESETEO DE CONTRASEÑA ===" -ForegroundColor Cyan
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

# Test 1: Solicitar reseteo de contraseña
Write-Host "1. Probando solicitud de reseteo de contraseña..." -ForegroundColor Yellow
$forgotData = @{
    email = "admin@lavianda.com"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "http://localhost:8000/api/forgot-password" -Method Post -Body $forgotData -ContentType "application/json"
    Show-Result "Forgot Password" $true $response.message
} catch {
    $errorMessage = $_.Exception.Message
    if ($_.Exception.Response) {
        $statusCode = $_.Exception.Response.StatusCode
        Show-Result "Forgot Password" $false "Error $statusCode - $errorMessage"
    } else {
        Show-Result "Forgot Password" $false "Error: $errorMessage"
    }
}

# Test 2: Verificar que el usuario existe
Write-Host "`n2. Verificando que el usuario existe..." -ForegroundColor Yellow
try {
    $loginData = @{
        email = "admin@lavianda.com"
        password = "password123"
    } | ConvertTo-Json

    $loginResponse = Invoke-RestMethod -Uri "http://localhost:8000/api/login" -Method Post -Body $loginData -ContentType "application/json"
    Show-Result "User Exists" $true "Usuario encontrado: $($loginResponse.user.name)"
} catch {
    Show-Result "User Exists" $false "Usuario no encontrado o credenciales incorrectas"
}

Write-Host "`n=== INFORMACIÓN IMPORTANTE ===" -ForegroundColor Cyan
Write-Host "📧 Para que el reseteo funcione completamente, necesitas:" -ForegroundColor Yellow
Write-Host "   1. Configurar el servidor de correo en .env" -ForegroundColor White
Write-Host "   2. Revisar el archivo .env para configuración SMTP" -ForegroundColor White
Write-Host "   3. El token se enviará por email al usuario" -ForegroundColor White
Write-Host ""
Write-Host "🔧 Configuración de .env necesaria:" -ForegroundColor Yellow
Write-Host "   MAIL_MAILER=smtp" -ForegroundColor White
Write-Host "   MAIL_HOST=smtp.gmail.com" -ForegroundColor White
Write-Host "   MAIL_PORT=587" -ForegroundColor White
Write-Host "   MAIL_USERNAME=tu_email@gmail.com" -ForegroundColor White
Write-Host "   MAIL_PASSWORD=tu_password" -ForegroundColor White
Write-Host "   MAIL_ENCRYPTION=tls" -ForegroundColor White
Write-Host ""
Write-Host "📝 Para probar sin email, puedes usar:" -ForegroundColor Yellow
Write-Host "   php artisan tinker" -ForegroundColor White
Write-Host "   >>> \$user = App\Models\User::where('email', 'admin@lavianda.com')->first();" -ForegroundColor White
Write-Host "   >>> \$token = Password::broker()->createToken(\$user);" -ForegroundColor White
Write-Host "   >>> echo \$token;" -ForegroundColor White
