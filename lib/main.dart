import 'package:flutter/material.dart';
import 'package:omsnepal/screens/screens.dart';
import 'package:omsnepal/services/preferences.dart';
import 'package:omsnepal/services/theme.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ThemeMode? defaultTheme = await sharedPreferenceService.getThemeMode();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<ThemeState>(
        create: (_) =>
            ThemeState(defaultTheme != null ? defaultTheme : ThemeMode.dark)),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<ThemeState>(context);
    return MaterialApp(
      title: 'OMS Nepal',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeState.themeMode,
      routes: {
        "/login": (BuildContext context) => LoginScreen(),
        "/home": (BuildContext context) => HomeScreen(),
      },
      home: SplashScreen(),
    );
  }
}
