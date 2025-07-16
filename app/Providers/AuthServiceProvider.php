<?php

namespace App\Providers;

use Illuminate\Foundation\Support\Providers\AuthServiceProvider as ServiceProvider;
// Ya no necesitamos importar 'Laravel\Passport\Passport' ni 'DateInterval'.

class AuthServiceProvider extends ServiceProvider
{
    /**
     * The model to policy mappings for the application.
     *
     * Aquí es donde en el futuro podrías definir reglas como:
     * "un usuario solo puede editar su propio perfil" o
     * "un administrador puede borrar los posts de otros".
     *
     * @var array<class-string, class-string>
     */
    protected $policies = [
        // 'App\Models\Post' => 'App\Policies\PostPolicy',
    ];

    /**
     * Register any authentication / authorization services.
     *
     * Al volver a Sanctum, no necesitamos ninguna configuración especial de Passport aquí.
     * El método boot() puede quedar vacío. Laravel Sanctum se configura
     * de una manera más automática.
     */
    public function boot(): void
    {
        //
    }
}