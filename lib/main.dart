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
    final isDark = context.select<AppProvider, bool>((p) => p.isDarkMode);
    return MaterialApp(
      title: 'Astrix DVC',
      debugShowCheckedModeBanner: false,
      theme: _theme(Brightness.light),
      darkTheme: _theme(Brightness.dark),
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      home: const HomeScreen(),
    );
  }

  ThemeData _theme(Brightness brightness) => ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF0077CC),
      brightness: brightness,
    ),
    useMaterial3: true,
  );
}
