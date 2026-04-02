import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_provider.dart';
import 'screens/home_screen.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initialize();
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppProvider(),
      child: const AstrixApp(),
    ),
  );
}

class AstrixApp extends StatelessWidget {
  const AstrixApp({super.key});

  @override
  Widget build(BuildContext context) {
    final followSystem = context.select<AppProvider, bool>(
      (p) => p.followSystemTheme,
    );
    final isDark = context.select<AppProvider, bool>((p) => p.isDarkMode);

    final themeMode = followSystem
        ? ThemeMode.system
        : (isDark ? ThemeMode.dark : ThemeMode.light);

    return MaterialApp(
      title: 'Astrix DVC',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      themeMode: themeMode,
      home: const HomeScreen(),
    );
  }

  ThemeData _buildTheme(Brightness brightness) => ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF0077CC),
      brightness: brightness,
    ),
    useMaterial3: true,
    // Add smooth transitions for theme animations
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}
