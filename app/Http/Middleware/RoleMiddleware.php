<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Symfony\Component\HttpFoundation\Response;

class RoleMiddleware
{
    /**
     * Handle an incoming request.
     *
     * @param  \Illuminate\Http\Request  $request La petición entrante.
     * @param  \Closure  $next La siguiente acción en el pipeline de la petición.
     * @param  string  ...$roles Una lista de los roles permitidos (ej. 'admin', 'empleado').
     * @return \Symfony\Component\HttpFoundation\Response
     */
    public function handle(Request $request, Closure $next, ...$roles): Response
    {
        // 1. Primero, verificamos si hay un usuario autenticado.
        // Si no, devolvemos un error 401 (No autenticado).
        if (!Auth::check()) {
            return response()->json(['message' => 'No autenticado.'], 401);
        }

        // 2. Obtenemos el modelo del usuario que está haciendo la petición.
        $user = Auth::user();

        // 3. Iteramos sobre la lista de roles que hemos permitido para esta ruta.
        // Los roles se pasan desde el archivo de rutas, ej: middleware('role:admin,root')
        foreach ($roles as $role) {
            // 4. Comparamos el rol del usuario con cada uno de los roles permitidos.
            if ($user->role === $role) {
                // Si encontramos una coincidencia, significa que el usuario tiene permiso.
                // Dejamos que la petición continúe hacia el controlador.
                return $next($request);
            }
        }
        
        // 5. Si el bucle termina y nunca encontramos una coincidencia,
        // significa que el rol del usuario no está en la lista de permitidos.
        // Devolvemos un error 403 (Prohibido/No autorizado).
        return response()->json([
            'message' => 'No autorizado. No tienes el rol requerido para acceder a este recurso.'
        ], 403);
    }
}