<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Location;
use App\Models\User;
use Carbon\Carbon;
use Illuminate\Http\Request;

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
            'activity_type' => ['nullable', 'string', 'max:50'],
            'notes' => ['nullable', 'string', 'max:255'],
            'timestamp' => ['nullable', 'date'],
        ]);

        // 4. Creamos el registro de ubicación asociado al usuario.
        $user->locations()->create([
            'latitude' => $data['latitude'],
            'longitude' => $data['longitude'],
            'activity_type' => $data['activity_type'] ?? 'location_update',
            'notes' => $data['notes'] ?? null,
            'recorded_at' => isset($data['timestamp']) ? Carbon::parse($data['timestamp']) : now(),
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
     * Devuelve todas las ubicaciones con marcaciones para mostrar en el mapa.
     */
    public function allLocations()
    {
        // Obtener todas las ubicaciones con información del usuario
        $locations = Location::with(['user:id,name,email'])
            ->join('users', 'locations.user_id', '=', 'users.id')
            ->where('users.role', 'empleado')
            ->select('locations.*', 'users.name as user_name')
            ->orderBy('recorded_at', 'desc')
            ->get();

        return response()->json([
            'locations' => $locations,
            'total' => $locations->count()
        ]);
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

        return response()->json([
            'trace' => $query->get(),
            'user' => $user->name
        ]);
    }
}