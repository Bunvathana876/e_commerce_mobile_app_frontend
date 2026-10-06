import 'package:flutter/material.dart';
import 'app/navigation/bottom_tab_navigator.dart';
import 'core/storage/secure_storage.dart';
import 'core/theme/theme_controller.dart';
import 'features/auth/screens/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Load saved session and theme settings
  final savedUser = await SessionStorage.load();
  await ThemeController.instance.load();
  runApp(MyApp(startLoggedIn: savedUser != null));
}

class MyApp extends StatelessWidget {
  /// true = open Home directly (a saved login exists).
  final bool startLoggedIn;

  const MyApp({super.key, this.startLoggedIn = false});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeController.instance,
      builder: (context, _) {
        return MaterialApp(
          title: 'ShopPenda',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeController.instance.themeMode,
          home: startLoggedIn
              ? const BottomTabNavigator()
              : const LoginScreen(),
        );
      },
    );
  }
}
