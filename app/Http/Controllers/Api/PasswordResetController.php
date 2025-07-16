<?php
namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Password;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Illuminate\Auth\Events\PasswordReset;

class PasswordResetController extends Controller
{
    public function sendResetLink(Request $request) {
        $validator = Validator::make($request->all(), ['email' => 'required|email']);
        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }
        $response = Password::broker()->sendResetLink($request->only('email'));
        return $response == Password::RESET_LINK_SENT
                    ? response()->json(['message' => 'Enlace de reseteo enviado.'], 200)
                    : response()->json(['message' => 'No se puede enviar el enlace de reseteo.'], 400);
    }

    public function resetPassword(Request $request) {
        $validator = Validator::make($request->all(), [
            'token' => 'required',
            'email' => 'required|email',
            'password' => 'required|confirmed|min:8',
        ]);
        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }
        $response = Password::broker()->reset(
            $request->only('email', 'password', 'password_confirmation', 'token'),
            function ($user, $password) {
                $user->forceFill(['password' => Hash::make($password)])->save();
                event(new PasswordReset($user));
            }
        );
        return $response == Password::PASSWORD_RESET
                    ? response()->json(['message' => 'Contraseña reseteada con éxito.'], 200)
                    : response()->json(['message' => 'Token inválido o correo incorrecto.'], 400);
    }
}