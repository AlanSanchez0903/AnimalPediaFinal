import 'package:flutter/material.dart';

import '../core/theme/app_text_styles.dart';
import '../core/utils/session_storage.dart';
import '../widgets/auth/auth_primary_button.dart';
import '../widgets/auth/auth_text_field.dart';
import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  static const String routeName = '/register';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isSubmitting = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final username = _usernameController.text.trim();
      final password = _passwordController.text;

      await SessionStorage.registerUser(username: username, password: password);

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(content: Text('Cuenta creada correctamente. ¡Bienvenido, $username!')),
        );

      Navigator.of(context).pushNamedAndRemoveUntil(HomeScreen.routeName, (route) => false);
    } on SessionStorageException catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(SnackBar(content: Text(error.message)));
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear cuenta')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Regístrate en Animalpedia', style: AppTextStyles.headlineMedium),
                    const SizedBox(height: 8),
                    Text(
                      'Crea un usuario local para iniciar sesión.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),
                    AuthTextField(
                      controller: _usernameController,
                      label: 'Username',
                      hintText: 'Mínimo 4 caracteres',
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        final username = value?.trim() ?? '';
                        if (username.isEmpty) {
                          return 'El username es obligatorio.';
                        }
                        if (username.length < SessionStorage.minUsernameLength) {
                          return 'El username debe tener mínimo ${SessionStorage.minUsernameLength} caracteres.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    AuthTextField(
                      controller: _passwordController,
                      label: 'Contraseña',
                      hintText: 'Mínimo 6 caracteres',
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        final password = value ?? '';
                        if (password.isEmpty) {
                          return 'La contraseña es obligatoria.';
                        }
                        if (password.length < SessionStorage.minPasswordLength) {
                          return 'La contraseña debe tener mínimo ${SessionStorage.minPasswordLength} caracteres.';
                        }
                        return null;
                      },
                      suffixIcon: IconButton(
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    AuthTextField(
                      controller: _confirmPasswordController,
                      label: 'Confirmar contraseña',
                      obscureText: _obscureConfirmPassword,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        final confirmPassword = value ?? '';
                        if (confirmPassword.isEmpty) {
                          return 'Debes confirmar tu contraseña.';
                        }
                        if (confirmPassword != _passwordController.text) {
                          return 'Las contraseñas no coinciden.';
                        }
                        return null;
                      },
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                        },
                        icon: Icon(
                          _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    AuthPrimaryButton(
                      text: 'Crear cuenta',
                      isLoading: _isSubmitting,
                      onPressed: _register,
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
                      child: const Text('¿Ya tienes cuenta? Inicia sesión'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
