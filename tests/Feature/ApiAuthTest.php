<?php

namespace Tests\Feature;

use Tests\TestCase;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Hash;

class ApiAuthTest extends TestCase
{
    use RefreshDatabase;

    public function test_user_can_register()
    {
        $response = $this->postJson('/api/register', [
            'name' => 'Test User',
            'email' => 'test@example.com',
            'password' => 'password123',
            'password_confirmation' => 'password123',
            'role' => 'empleado'
        ]);

        $response->assertStatus(201)
                ->assertJsonStructure([
                    'message',
                    'user' => ['id', 'name', 'email', 'role']
                ]);

        $this->assertDatabaseHas('users', [
            'email' => 'test@example.com',
            'role' => 'empleado'
        ]);
    }

    public function test_user_can_login()
    {
        $user = User::factory()->create([
            'email' => 'test@example.com',
            'password' => Hash::make('password123'),
            'role' => 'empleado'
        ]);

        $response = $this->postJson('/api/login', [
            'email' => 'test@example.com',
            'password' => 'password123'
        ]);

        $response->assertStatus(200)
                ->assertJsonStructure([
                    'message',
                    'access_token',
                    'token_type',
                    'user'
                ]);
    }

    public function test_user_can_access_profile_with_token()
    {
        $user = User::factory()->create(['role' => 'empleado']);
        $token = $user->createToken('test-token')->plainTextToken;

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $token,
        ])->getJson('/api/user');

        $response->assertStatus(200)
                ->assertJson([
                    'id' => $user->id,
                    'email' => $user->email
                ]);
    }

    public function test_empleado_can_access_empleado_route()
    {
        $user = User::factory()->create(['role' => 'empleado']);
        $token = $user->createToken('test-token')->plainTextToken;

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $token,
        ])->getJson('/api/empleado/marcar');

        $response->assertStatus(200)
                ->assertJson([
                    'message' => 'Asistencia marcada con éxito'
                ]);
    }

    public function test_empleado_cannot_access_admin_route()
    {
        $user = User::factory()->create(['role' => 'empleado']);
        $token = $user->createToken('test-token')->plainTextToken;

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $token,
        ])->getJson('/api/admin/panel');

        $response->assertStatus(403)
                ->assertJson([
                    'message' => 'Sin permisos'
                ]);
    }

    public function test_admin_can_access_admin_route()
    {
        $user = User::factory()->create(['role' => 'admin']);
        $token = $user->createToken('test-token')->plainTextToken;

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $token,
        ])->getJson('/api/admin/panel');

        $response->assertStatus(200)
                ->assertJson([
                    'message' => 'Bienvenido al panel de Administrador'
                ]);
    }

    public function test_user_can_logout()
    {
        $user = User::factory()->create(['role' => 'empleado']);
        $token = $user->createToken('test-token')->plainTextToken;

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $token,
        ])->postJson('/api/logout');

        $response->assertStatus(200)
                ->assertJson([
                    'message' => 'Logout exitoso'
                ]);
    }

    public function test_unauthenticated_user_cannot_access_protected_routes()
    {
        $response = $this->getJson('/api/user');
        $response->assertStatus(401);

        $response = $this->getJson('/api/empleado/marcar');
        $response->assertStatus(401);

        $response = $this->getJson('/api/admin/panel');
        $response->assertStatus(401);
    }
}
