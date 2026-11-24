import 'package:flutter/material.dart';
import 'package:earthquake/core/theme/app_theme.dart';
import 'package:earthquake/features/home/controllers/earthquake_provider.dart';
import 'package:earthquake/features/home/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const EarthquakeApp());
}
class EarthquakeApp extends StatelessWidget {
  const EarthquakeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EarthquakeProvider()..fetchEarthquakes(),
      child: MaterialApp(
        title: 'Earthquake Tracker',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home: const HomeScreen(),
      ),
    );
  }
}

