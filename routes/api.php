<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\PasswordResetController;
use App\Http\Controllers\Api\LocationController;

// --- Rutas Públicas ---
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']); // <-- Se usa para el login con Sanctum
Route::post('/forgot-password', [PasswordResetController::class, 'sendResetLink']);
Route::post('/reset-password', [PasswordResetController::class, 'resetPassword']);

// --- Rutas Protegidas ---
Route::middleware('auth:sanctum')->group(function () {
    // Rutas para todos los usuarios autenticados
    Route::get('/user', [AuthController::class, 'user']);
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::post('/location/update', [LocationController::class, 'store']);
    Route::post('/user/profile-photo', [AuthController::class, 'updateProfilePhoto']);
    
    // Rutas de ubicaciones
    Route::get('/locations', [LocationController::class, 'allLocations']);

    // Rutas protegidas por rol
    Route::middleware(['role:admin,root'])->prefix('admin')->group(function () {
        Route::get('/users/locations', [LocationController::class, 'latestLocations']);
        Route::get('/user/{user}/trace', [LocationController::class, 'userTrace']);
    });
});