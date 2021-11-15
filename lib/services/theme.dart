import 'package:flutter/material.dart';
import 'package:omsnepal/services/preferences.dart';
import 'package:google_fonts/google_fonts.dart';

const Color PRIMARY_BACKGROUND = Color(0xeec26d13);
const Color LIGHT_TEXT_COLOR_NORMAL = Color(0xff28607a);
const Color LIGHT_TEXT_COLOR_BOLD = Color(0xff17475B);

// const Color PRIMARY_BACKGROUND = Colors.purple;

// const Color PRIMARY_LIGHT_BACKGROUND = Color(0xee83e6d9);

ThemeData lightTheme = ThemeData.light().copyWith(
  indicatorColor: Color(0xff49B0C0),
  // indicatorColor: Colors.amber[700],
  primaryColor: Color(0xff49B0C0),
  backgroundColor: Colors.white70,

  textTheme: GoogleFonts.mcLarenTextTheme(ThemeData.light()
      .textTheme
      .copyWith(
        headline6: ThemeData.light().textTheme.headline5!.copyWith(
            fontSize: textTheme.headline6!.fontSize,
            fontWeight: textTheme.headline6!.fontWeight),
        headline5: ThemeData.light().textTheme.headline5!.copyWith(
            fontSize: textTheme.headline5!.fontSize,
            fontWeight: textTheme.headline5!.fontWeight),
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
        subtitle1: ThemeData.light().textTheme.bodyText2!.copyWith(
            fontSize: textTheme.subtitle1!.fontSize,
            fontWeight: textTheme.subtitle1!.fontWeight),
      )
      .apply(
        displayColor: LIGHT_TEXT_COLOR_BOLD,
      )),

  // textTheme: textTheme
);

ThemeData darkTheme = ThemeData.dark().copyWith(
    indicatorColor: Color(0xff49B0C0),

    // indicatorColor: Colors.amber[700],
    textTheme: GoogleFonts.mcLarenTextTheme(ThemeData.dark()
        .textTheme
        .copyWith(
          headline6: ThemeData.dark().textTheme.headline5!.copyWith(
              fontSize: textTheme.headline6!.fontSize,
              fontWeight: textTheme.headline6!.fontWeight),
          headline5: ThemeData.dark().textTheme.headline5!.copyWith(
              fontSize: textTheme.headline5!.fontSize,
              fontWeight: textTheme.headline5!.fontWeight),
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
          subtitle1: ThemeData.dark().textTheme.bodyText2!.copyWith(
              fontSize: textTheme.subtitle1!.fontSize,
              fontWeight: textTheme.subtitle1!.fontWeight),
        )
        .apply(
          displayColor: Colors.white,
        ))
    // textTheme: ThemeData().
    // textTheme: GoogleFonts.latoTextTheme()
    // textTheme: ThemeData.dark().textTheme.copyWith(
    //       headline4: ThemeData.dark().textTheme.headline4!.copyWith(
    //           fontSize: textTheme.headline4!.fontSize,
    //           fontWeight: textTheme.headline4!.fontWeight),
    //       headline3: ThemeData.dark().textTheme.headline3!.copyWith(
    //           fontSize: textTheme.headline3!.fontSize,
    //           fontWeight: textTheme.headline3!.fontWeight),
    //       bodyText1: ThemeData.dark().textTheme.bodyText1!.copyWith(
    //           fontSize: textTheme.bodyText1!.fontSize,
    //           fontWeight: textTheme.bodyText1!.fontWeight),
    //       bodyText2: ThemeData.dark().textTheme.bodyText2!.copyWith(
    //           fontSize: textTheme.bodyText2!.fontSize,
    //           fontWeight: textTheme.bodyText2!.fontWeight),
    //     )
    );

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
      // Color(0xFF73AEF5),
      // Color(0xFF61A4F1),
      // Color(0xFF478DE0),
      // Color(0xFF398AE5),
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
  headline5: TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
  ),
  headline6: TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.bold,
  ),
  bodyText1: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
  bodyText2: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.0),
  subtitle1: TextStyle(fontWeight: FontWeight.bold, fontSize: 11.0),
);
