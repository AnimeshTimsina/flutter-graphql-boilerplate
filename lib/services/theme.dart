import 'package:flutter/material.dart';
import 'package:omsnepal/services/preferences.dart';

const Color PRIMARY_BACKGROUND = Color(0xee00796b);
// const Color PRIMARY_BACKGROUND = Colors.purple;

const Color PRIMARY_LIGHT_BACKGROUND = Color(0xee83e6d9);

ThemeData lightTheme = ThemeData.light().copyWith(
  accentColor: Colors.green[700],
  primaryColor: Colors.teal[600],
  textTheme: ThemeData.light().textTheme.copyWith(
        headline4: ThemeData.light().textTheme.headline4!.copyWith(
            fontSize: textTheme.headline4!.fontSize,
            fontWeight: textTheme.headline4!.fontWeight),
        headline3: ThemeData.light().textTheme.headline3!.copyWith(
            fontSize: textTheme.headline3!.fontSize,
            fontWeight: textTheme.headline3!.fontWeight),
        bodyText1: ThemeData.light().textTheme.bodyText1!.copyWith(
            fontSize: textTheme.bodyText1!.fontSize,
            fontWeight: textTheme.bodyText1!.fontWeight),
        bodyText2: ThemeData.light().textTheme.bodyText2!.copyWith(
            fontSize: textTheme.bodyText2!.fontSize,
            fontWeight: textTheme.bodyText2!.fontWeight),
      ),

  // textTheme: textTheme
);

ThemeData darkTheme = ThemeData.dark().copyWith(
    accentColor: Colors.teal[400],
    textTheme: ThemeData.dark().textTheme.copyWith(
          headline4: ThemeData.dark().textTheme.headline4!.copyWith(
              fontSize: textTheme.headline4!.fontSize,
              fontWeight: textTheme.headline4!.fontWeight),
          headline3: ThemeData.dark().textTheme.headline3!.copyWith(
              fontSize: textTheme.headline3!.fontSize,
              fontWeight: textTheme.headline3!.fontWeight),
          bodyText1: ThemeData.dark().textTheme.bodyText1!.copyWith(
              fontSize: textTheme.bodyText1!.fontSize,
              fontWeight: textTheme.bodyText1!.fontWeight),
          bodyText2: ThemeData.dark().textTheme.bodyText2!.copyWith(
              fontSize: textTheme.bodyText2!.fontSize,
              fontWeight: textTheme.bodyText2!.fontWeight),
        ));

class ThemeState extends ChangeNotifier {
  ThemeMode? _themeMode;

  ThemeMode? get themeMode => this._themeMode;
  set themeMode(ThemeMode? mode) {
    _themeMode = mode;
    notifyListeners();
  }

  ThemeState(ThemeMode mode) {
    _themeMode = mode;
  }

  toggleTheme() async {
    themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
    sharedPreferenceService.setThemeMode(_themeMode);
  }
}

BoxDecoration backgroundDecor = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xdd02a894),
      Color(0xdd029987),
      Color(0xdd038777),
      Color(0xdd00796b),
    ],
    stops: [0.1, 0.4, 0.7, 0.9],
  ),
);

TextTheme textTheme = TextTheme(
  headline4: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
  headline3: TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
  ),
  bodyText1: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
  bodyText2: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.0),
);
