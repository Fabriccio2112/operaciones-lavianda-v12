<?php

namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;
use App\Notifications\ApiPasswordResetNotification;
use Illuminate\Support\Facades\Storage; // Importante para manejar el almacenamiento
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\HasOne;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'name',
        'email',
        'password',
        'role',
        'profile_photo_path', // Correcto
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var array<int, string>
     */
    protected $hidden = [
        'password',
        'remember_token',
        'profile_photo_path', // 1. Ocultamos la ruta cruda del archivo
    ];

    /**
     * The attributes that should be cast.
     *
     * @var array<string, string>
     */
    protected $casts = [
        'email_verified_at' => 'datetime',
        'password' => 'hashed',
        'role' => 'string',
    ];

    /**
     * The accessors to append to the model's array form.
     *
     * @var array<int, string>
     */
    protected $appends = [
        'profile_photo_url', // 2. Añadimos la URL completa al JSON de respuesta
    ];

    /**
     * Obtiene la URL completa de la foto de perfil del usuario.
     */
    public function getProfilePhotoUrlAttribute(): string
    {
        // Si existe la foto, generamos la URL completa
        if ($this->profile_photo_path && Storage::disk('public')->exists($this->profile_photo_path)) {
            return asset('storage/' . $this->profile_photo_path);
        }

        // Si no hay foto, generamos un avatar por defecto
        return 'https://ui-avatars.com/api/?name=' . urlencode($this->name) . '&color=C62828&background=E3F2FD&bold=true';
    }

    /**
     * Envía la notificación de reseteo de contraseña personalizada para la API.
     *
     * @param  string  $token
     * @return void
     */
    public function sendPasswordResetNotification($token)
    {
        $this->notify(new ApiPasswordResetNotification($token));
    }

    public function locations(): HasMany
    {
        return $this->hasMany(Location::class);
    }

     public function latestLocation(): HasOne
    {
        return $this->hasOne(Location::class)->latestOfMany('recorded_at');
    }
}