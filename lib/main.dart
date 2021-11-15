import 'package:flutter/material.dart';
import 'package:omsnepal/screens/screens.dart';
import 'package:omsnepal/services/auth.dart';
import 'package:omsnepal/services/preferences.dart';
import 'package:omsnepal/services/theme.dart';
import 'package:provider/provider.dart';

import 'services/orders/orderState.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // NepaliUtils(Language.nepali);

  ThemeMode? defaultTheme = await sharedPreferenceService.getThemeMode();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<ThemeState>(
        create: (_) =>
            ThemeState(defaultTheme != null ? defaultTheme : ThemeMode.light)),
    ChangeNotifierProvider<AuthState>(create: (_) => AuthState()),
    ChangeNotifierProvider<OrderState>(create: (_) => OrderState()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<ThemeState>(context);
    final authState = Provider.of<AuthState>(context);
    return MaterialApp(
      title: 'OMS Nepal',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeState.themeMode,
      routes: {
        "/login": (BuildContext context) => LoginScreen(),
        "/home": (BuildContext context) => HomeScreen(),
        "/password-reset": (BuildContext context) => PasswordResetScreen(),
        "/cart": (BuildContext context) => CartScreen(),
        "/new-customer": (BuildContext context) => NewCustomerContainer(),
        "/existing-customer": (BuildContext context) =>
            ExistingCustomerContainer(),
        "/checkout": (BuildContext context) => CheckoutScreen(),
      },
      home: SplashScreen(authState: authState),
    );
  }
}
