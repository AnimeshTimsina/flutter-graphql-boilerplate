import 'dart:async';
import 'package:flutter/material.dart';
import 'package:omsnepal/models/constants.dart';
import 'package:omsnepal/services/auth.dart';
import 'package:omsnepal/services/preferences.dart';
// import 'package:omsnepal/services/theme.dart';
import 'package:omsnepal/utils/contrastTestColor.dart';
import 'package:omsnepal/widgets/widgets.dart';

class SplashScreen extends StatefulWidget {
  final AuthState authState;
  const SplashScreen({Key? key, required this.authState}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    automaticLogin();
  }

  automaticLogin() async {
    String? token = await sharedPreferenceService.token;
    if (token == null) {
      Timer(
          Duration(seconds: 2),
          () => Navigator.pushReplacementNamed(
                context,
                '/login',
              ));
    } else {
      widget.authState.automaticLogin(token);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.authState.loadingStateUserFetch == LoadingState.error) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(
          context,
          '/login',
        );
        if (widget.authState.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(snackbar(
              text: widget.authState.errorMessage!, color: Colors.red));
        }
      });
    } else if (widget.authState.loadingStateUserFetch == LoadingState.loaded &&
        widget.authState.userInfo != null) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/home');
      });
    }
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
              // decoration: BoxDecoration(color: PRIMARY_BACKGROUND),
              ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  flex: 2,
                  child: Container(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/logo.png',
                        height: 250,
                        width: 250,
                      ),
                      SizedBox(height: 10),
                      // Text(
                      //   'OMS Nepal',
                      //   style: TextStyle(
                      //       color: getContrastTextLight(
                      //           Theme.of(context).backgroundColor),
                      //       fontSize: 23.0,
                      //       fontWeight: FontWeight.bold),
                      // )
                    ],
                  ))),
              Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator.adaptive(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            getContrastTextLight(
                                Theme.of(context).backgroundColor)),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Loading...",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: getContrastTextLight(
                                Theme.of(context).backgroundColor),
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  ))
            ],
          )
        ],
      ),
    );
  }
}
