import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'services/tts_service.dart';
import 'features/nursery/colours/presentation/colours_list_screen.dart';

/// ⭐ Route observer used to detect when we return to a screen
final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Text-to-Speech engine (Indian English)
  await TTSService().init();

  runApp(const EduSwasthyaApp());
}

class EduSwasthyaApp extends StatelessWidget {
  const EduSwasthyaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EduSwasthya',
      theme: AppTheme.lightTheme,

      /// ⭐ Attach navigator observer here
      navigatorObservers: [routeObserver],

      home: const SplashScreen(),
    );
  }
}