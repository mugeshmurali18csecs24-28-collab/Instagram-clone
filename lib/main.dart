import 'package:flutter/material.dart';
import 'providers/app_state.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const ConnectlyApp());
}

class ConnectlyApp extends StatefulWidget {
  const ConnectlyApp({super.key});

  @override
  State<ConnectlyApp> createState() => _ConnectlyAppState();
}

class _ConnectlyAppState extends State<ConnectlyApp> {
  final AppState _appState = AppState();

  @override
  Widget build(BuildContext context) {
    return AppStateProvider(
      notifier: _appState,
      child: MaterialApp(
        title: 'Connectly',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
