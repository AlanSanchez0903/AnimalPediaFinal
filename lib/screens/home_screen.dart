import 'package:flutter/material.dart';

import '../core/constants/app_constants.dart';
import '../core/utils/session_storage.dart';
import 'animal_map_screen.dart';
import 'animal_collection_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<String> _usernameFuture;

  @override
  void initState() {
    super.initState();
    _usernameFuture = _loadUsername();
  }

  Future<String> _loadUsername() async {
    final username = await SessionStorage.getRegisteredUsername();
    return (username == null || username.trim().isEmpty) ? 'Explorador' : username.trim();
  }

  Future<void> _logout() async {
    await SessionStorage.clearSession();

    if (!mounted) {
      return;
    }

    Navigator.of(context).pushNamedAndRemoveUntil(LoginScreen.routeName, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF111111), Color(0xFF0B0B0B), Color(0xFF070707)],
          ),
        ),
        child: SafeArea(
          child: FutureBuilder<String>(
            future: _usernameFuture,
            builder: (context, snapshot) {
              final username = snapshot.data ?? 'Explorador';

              return LayoutBuilder(
                builder: (context, constraints) {
                  final contentMaxWidth = constraints.maxWidth > 1000 ? 980.0 : 760.0;
                  final crossAxisCount = constraints.maxWidth >= 780 ? 2 : 1;

                  return Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: contentMaxWidth),
                      child: CustomScrollView(
                        physics: const BouncingScrollPhysics(),
                        slivers: [
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                              child: _HeroHeader(username: username),
                            ),
                          ),
                          SliverPadding(
                            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                            sliver: SliverGrid(
                              delegate: SliverChildListDelegate.fixed([
                                _FeatureCard(
                                  title: 'Explorar mapa',
                                  subtitle:
                                      'Ubica regiones y hábitats para iniciar nuevas expediciones.',
                                  icon: Icons.map_outlined,
                                  accentColor: const Color(0xFF6F8CFF),
                                  onTap: () => _openFeature(const AnimalMapScreen()),
                                ),
                                _FeatureCard(
                                  title: 'Animales descubiertos',
                                  subtitle: 'Consulta los animales que ya registraste en tu bitácora.',
                                  icon: Icons.pets_outlined,
                                  accentColor: const Color(0xFF5EC8A7),
                                  onTap: () => _openFeature(
                                    const AnimalCollectionScreen(showOnlyDiscovered: true),
                                  ),
                                ),
                                _FeatureCard(
                                  title: 'Animales por descubrir',
                                  subtitle:
                                      'Revisa pendientes y planifica tu próxima exploración.',
                                  icon: Icons.visibility_outlined,
                                  accentColor: const Color(0xFFE29B63),
                                  onTap: () => _openFeature(
                                    const AnimalCollectionScreen(showOnlyUndiscovered: true),
                                  ),
                                ),
                                _FeatureCard(
                                  title: 'Cerrar sesión',
                                  subtitle: 'Salir de tu cuenta y volver a la pantalla de inicio de sesión.',
                                  icon: Icons.logout_rounded,
                                  accentColor: const Color(0xFFE16B6B),
                                  onTap: _logout,
                                ),
                              ]),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                                mainAxisExtent: 180,
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              child: Text(
                                'Tip: toca cualquier tarjeta para continuar.',
                                style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _openFeature(Widget screen) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => screen),
    );
  }
}

class _HeroHeader extends StatelessWidget {
  const _HeroHeader({required this.username});

  final String username;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white.withOpacity(0.05),
        border: Border.all(color: Colors.white.withOpacity(0.09)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppConstants.appName,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Hola, $username 👋',
              style: theme.textTheme.titleLarge?.copyWith(fontSize: 24),
            ),
            const SizedBox(height: 6),
            Text(
              'Tu centro de exploración ya está listo. ¿Qué quieres hacer hoy?',
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70, height: 1.35),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: Colors.white.withOpacity(0.03),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.16),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: accentColor, size: 24),
                ),
                const SizedBox(height: 14),
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Expanded(
                  child: Text(
                    subtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                      height: 1.32,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: Icon(Icons.arrow_forward_rounded, color: accentColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
