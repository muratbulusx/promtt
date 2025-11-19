import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'firebase/firebase_service.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/screens/auth/login_screen.dart';
import 'presentation/screens/auth/profile_setup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Note: Firebase initialization will be done asynchronously in SplashScreen
  // to avoid blocking the app startup

  runApp(
    /// Setup providers
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        // Additional providers will be added here
      ],
      child: const LimoncukApp(),
    ),
  );
}

class LimoncukApp extends StatelessWidget {
  const LimoncukApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Limoncuk Eğitim',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      // Initialize Firebase (commented out until firebase_options.dart is generated)
      // await FirebaseService().initialize();

      // Initialize AuthProvider
      final authProvider = context.read<AuthProvider>();
      await authProvider.initialize();

      // Wait for a minimum splash duration
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      // Navigate based on auth state
      _navigateToAppropriateScreen(authProvider);
    } catch (e) {
      debugPrint('Initialization error: $e');
      if (!mounted) return;

      // Navigate to login screen even if there's an error
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  void _navigateToAppropriateScreen(AuthProvider authProvider) {
    Widget targetScreen;

    if (authProvider.isAuthenticated) {
      if (authProvider.hasCompletedProfile) {
        // TODO: Navigate to Home Screen when it's implemented
        targetScreen = const Scaffold(
          body: Center(
            child: Text('Home Screen (Coming Soon)'),
          ),
        );
      } else {
        // Navigate to Profile Setup
        targetScreen = const ProfileSetupScreen();
      }
    } else {
      // Navigate to Login
      targetScreen = const LoginScreen();
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => targetScreen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFC107),
              Color(0xFFFF6F00),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Icon/Logo
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    '🍋',
                    style: TextStyle(fontSize: 60),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // App Name
              const Text(
                'Limoncuk Eğitim',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 8),
              // Tagline
              const Text(
                'AI Destekli Soru Çözüm Asistanı',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 48),
              // Loading Indicator
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
