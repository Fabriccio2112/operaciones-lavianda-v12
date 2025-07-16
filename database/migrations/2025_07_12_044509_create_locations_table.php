<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('locations', function (Blueprint $table) {
        $table->id();
        $table->foreignId('user_id')->constrained()->onDelete('cascade'); // Enlaza con el usuario
        $table->decimal('latitude', 10, 7); // Precisión para latitud
        $table->decimal('longitude', 10, 7); // Precisión para longitud
        $table->timestamp('recorded_at'); // La hora exacta de la ubicación
        $table->timestamps(); // created_at y updated_at
    });
       
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('locations');
    }
};
