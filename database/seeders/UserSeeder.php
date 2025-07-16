<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\User;
use Illuminate\Support\Facades\Hash;

class UserSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // Admin user
        User::create([
            'name' => 'Administrador',
            'email' => 'admin@ejemplo.com',
            'password' => Hash::make('12345678'),
            'role' => 'admin',
            'email_verified_at' => now(),
        ]);

        // Root user
        User::create([
            'name' => 'Super Usuario',
            'email' => 'root@ejemplo.com',
            'password' => Hash::make('12345678'),
            'role' => 'root',
            'email_verified_at' => now(),
        ]);

        // Empleado user
        User::create([
            'name' => 'Juan Empleado',
            'email' => 'empleado@ejemplo.com',
            'password' => Hash::make('12345678'),
            'role' => 'empleado',
            'email_verified_at' => now(),
        ]);

        // Guest user
        User::create([
            'name' => 'Usuario Invitado',
            'email' => 'guest@ejemplo.com',
            'password' => Hash::make('12345678'),
            'role' => 'guest',
            'email_verified_at' => now(),
        ]);
    }
}
