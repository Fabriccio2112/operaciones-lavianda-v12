# Script de pruebas automatizado para la API Laravel
# Ejecutar: .\test-api.ps1

Write-Host "🚀 Iniciando pruebas de la API..." -ForegroundColor Green
Write-Host ""

# Configuración
$baseUrl = "http://localhost:8000/api"
$headers = @{
    "Content-Type" = "application/json"
    "Accept" = "application/json"
}

# Función para hacer peticiones HTTP
function Invoke-ApiRequest {
    param(
        [string]$Method,
        [string]$Endpoint,
        [hashtable]$Headers = $headers,
        [string]$Body = $null
    )
    
    try {
        $url = "$baseUrl$Endpoint"
        Write-Host "📡 $Method $url" -ForegroundColor Yellow
        
        $params = @{
            Uri = $url
            Method = $Method
            Headers = $Headers
        }
        
        if ($Body) {
            $params.Body = $Body
            Write-Host "📝 Body: $Body" -ForegroundColor Gray
        }
        
        $response = Invoke-RestMethod @params
        Write-Host "✅ Status: OK" -ForegroundColor Green
        Write-Host "📋 Response: $($response | ConvertTo-Json -Depth 3)" -ForegroundColor Cyan
        return $response
    }
    catch {
        Write-Host "❌ Error: $($_.Exception.Message)" -ForegroundColor Red
        if ($_.Exception.Response) {
            $errorStream = $_.Exception.Response.GetResponseStream()
            $reader = New-Object System.IO.StreamReader($errorStream)
            $errorContent = $reader.ReadToEnd()
            Write-Host "📋 Error Response: $errorContent" -ForegroundColor Red
        }
        return $null
    }
}

Write-Host "1️⃣  Probando registro de usuario..." -ForegroundColor Blue
$registerData = @{
    name = "Usuario Prueba"
    email = "prueba@ejemplo.com"
    password = "12345678"
    password_confirmation = "12345678"
    role = "empleado"
} | ConvertTo-Json

$registerResponse = Invoke-ApiRequest -Method "POST" -Endpoint "/register" -Body $registerData
Write-Host ""

Write-Host "2️⃣  Probando login..." -ForegroundColor Blue
$loginData = @{
    email = "prueba@ejemplo.com"
    password = "12345678"
} | ConvertTo-Json

$loginResponse = Invoke-ApiRequest -Method "POST" -Endpoint "/login" -Body $loginData

if ($loginResponse -and $loginResponse.access_token) {
    $token = $loginResponse.access_token
    $authHeaders = $headers.Clone()
    $authHeaders["Authorization"] = "Bearer $token"
    
    Write-Host ""
    Write-Host "3️⃣  Probando perfil de usuario (con token)..." -ForegroundColor Blue
    Invoke-ApiRequest -Method "GET" -Endpoint "/user" -Headers $authHeaders
    
    Write-Host ""
    Write-Host "4️⃣  Probando ruta de empleado..." -ForegroundColor Blue
    Invoke-ApiRequest -Method "GET" -Endpoint "/empleado/marcar" -Headers $authHeaders
    
    Write-Host ""
    Write-Host "5️⃣  Probando ruta de admin (debería fallar)..." -ForegroundColor Blue
    Invoke-ApiRequest -Method "GET" -Endpoint "/admin/panel" -Headers $authHeaders
    
    Write-Host ""
    Write-Host "6️⃣  Probando logout..." -ForegroundColor Blue
    Invoke-ApiRequest -Method "POST" -Endpoint "/logout" -Headers $authHeaders
}

Write-Host ""
Write-Host "7️⃣  Probando acceso sin token (debería fallar)..." -ForegroundColor Blue
Invoke-ApiRequest -Method "GET" -Endpoint "/user"

Write-Host ""
Write-Host "🎉 Pruebas completadas!" -ForegroundColor Green

Write-Host ""
Write-Host "📚 Para crear un admin, ejecuta en tu terminal:" -ForegroundColor Yellow
Write-Host "php artisan tinker" -ForegroundColor Gray
Write-Host "User::create(['name' => 'Admin', 'email' => 'admin@ejemplo.com', 'password' => Hash::make('12345678'), 'role' => 'admin'])" -ForegroundColor Gray
