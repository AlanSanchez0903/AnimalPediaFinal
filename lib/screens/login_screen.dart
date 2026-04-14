import 'package:flutter/material.dart';

import '../core/theme/app_text_styles.dart';
import '../core/utils/session_storage.dart';
import '../widgets/auth/auth_primary_button.dart';
import '../widgets/auth/auth_text_field.dart';
import 'home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const String routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isSubmitting = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final hasUser = await SessionStorage.hasRegisteredUser();
      if (!hasUser) {
        _showError('Aún no existe un usuario registrado. Crea tu cuenta primero.');
        return;
      }

      final credentialsAreValid = await SessionStorage.validateCredentials(
        username: _usernameController.text.trim(),
        password: _passwordController.text,
      );

      if (!credentialsAreValid) {
        _showError('Usuario o contraseña incorrectos. Revisa tus datos.');
        return;
      }

      await SessionStorage.setCurrentAuthenticatedUser(_usernameController.text.trim());
      await SessionStorage.saveSessionStatus(true);

      if (!mounted) {
        return;
      }

      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  void _showError(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(content: Text(message)),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar sesión')),
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
                    Text('Bienvenido a Animalpedia', style: AppTextStyles.headlineMedium),
                    const SizedBox(height: 8),
                    Text(
                      'Inicia sesión para continuar.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),
                    AuthTextField(
                      controller: _usernameController,
                      label: 'Username',
                      hintText: 'Ej: raccoonlover',
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        final username = value?.trim() ?? '';
                        if (username.isEmpty) {
                          return 'Ingresa tu username.';
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
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        final password = value ?? '';
                        if (password.isEmpty) {
                          return 'Ingresa tu contraseña.';
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
                    const SizedBox(height: 24),
                    AuthPrimaryButton(
                      text: 'Entrar',
                      isLoading: _isSubmitting,
                      onPressed: _login,
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: _isSubmitting
                          ? null
                          : () {
                              Navigator.of(context).pushNamed(RegisterScreen.routeName);
                            },
                      child: const Text('¿No tienes cuenta? Regístrate'),
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
