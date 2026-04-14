import 'package:flutter/material.dart';

import '../core/utils/asset_paths.dart';
import '../core/utils/session_storage.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String routeName = '/';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const Duration _splashDuration = Duration(seconds: 2);

  @override
  void initState() {
    super.initState();
    _handleStartup();
  }

  Future<void> _handleStartup() async {
    final hasSession = await SessionStorage.hasActiveSession();

    await Future<void>.delayed(_splashDuration);

    if (!mounted) {
      return;
    }

    final targetRoute = hasSession ? HomeScreen.routeName : LoginScreen.routeName;

    Navigator.of(context).pushReplacementNamed(targetRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              AssetPaths.raccoonGif,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
