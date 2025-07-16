<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\User;
use Carbon\Carbon; // No se está usando, se puede quitar si quieres

class LocationController extends Controller
{
    /**
     * Almacena la ubicación enviada por un usuario.
     */
    public function store(Request $request)
    {
        // 1. Obtenemos el usuario autenticado primero.
        $user = $request->user();

        // 2. ¡VALIDACIÓN DE SEGURIDAD CRUCIAL!
        // Verificamos si el rol del usuario es 'empleado'.
        if ($user->role !== 'empleado') {
            // Si no lo es, devolvemos un error de "Prohibido".
            return response()->json(['message' => 'Solo los empleados pueden reportar su ubicación.'], 403);
        }

        // 3. Validamos los datos de entrada.
        $data = $request->validate([
            'latitude' => ['required', 'numeric', 'between:-90,90'],
            'longitude' => ['required', 'numeric', 'between:-180,180'],
        ]);

        // 4. Creamos el registro de ubicación asociado al usuario.
        $user->locations()->create([
            'latitude' => $data['latitude'],
            'longitude' => $data['longitude'],
            'recorded_at' => now(), // `now()` es un helper de Laravel, más limpio que Carbon::now()
        ]);

        return response()->json(['message' => 'Ubicación registrada con éxito.']);
    }

    /**
     * Devuelve la última ubicación conocida de todos los usuarios rastreables.
     */
    public function latestLocations()
    {
        // Optimizamos la consulta para traer solo empleados con ubicaciones.
        $usersWithLocation = User::where('role', 'empleado')
            ->whereHas('locations')
            ->with(['latestLocation']) // Carga la relación que definimos en el modelo User
            ->get();

        return response()->json($usersWithLocation);
    }
    
    /**
     * Devuelve el historial de ubicaciones (trazabilidad) de un usuario específico.
     */
    public function userTrace(User $user, Request $request)
    {
        $request->validate(['date' => 'sometimes|date_format:Y-m-d']);
        
        $query = $user->locations()->orderBy('recorded_at', 'asc');
        
        if ($request->has('date')) {
            $query->whereDate('recorded_at', $request->date);
        }

        return response()->json($query->get());
    }
}