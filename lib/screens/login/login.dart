import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:omsnepal/models/constants.dart';
import 'package:omsnepal/screens/login/form.dart';
import 'package:omsnepal/screens/login/styles.dart';
import 'package:omsnepal/services/auth.dart';
import 'package:omsnepal/services/theme.dart';
import 'package:omsnepal/utils/contrastTestColor.dart';
// import 'package:omsnepal/services/theme.dart';
import 'package:omsnepal/widgets/button.dart';
import 'package:omsnepal/widgets/form-fields.dart';
import 'package:omsnepal/widgets/widgets.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginFormData form =
      LoginFormData(email: null, password: null, remember: true);
  final _formKey = GlobalKey<FormState>();
  final focusPassword = FocusNode();

  _login(AuthState authState) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await authState.login(
          email: form.email ?? '',
          password: form.password ?? '',
          remember: form.remember);
      if (authState.loadingStateUserLogin == LoadingState.loaded &&
          authState.token != null &&
          authState.userInfo != null) {
        _formKey.currentState!.reset();
        Navigator.pushReplacementNamed(context, '/home');
      } else if (authState.loadingStateUserLogin == LoadingState.error) {
        ScaffoldMessenger.of(context).showSnackBar(snackbar(
            text: authState.errorMessage != null
                ? authState.errorMessage!
                : "Login failed",
            color: Colors.red));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          snackbar(text: "Fields cannot be empty", color: Colors.red));
    }
  }

  Widget _buildEmailTF() {
    final textColor = getContrastTextLight(Theme.of(context).backgroundColor);
    return emailField(
      context: context,
      nextFocusNode: focusPassword,
      onSaved: (String? value) {
        setState(() {
          form.setEmail(value ?? '');
        });
      },
      labelColor: textColor,
      hintTextColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.white54
          : Colors.black54,
      prefixIconColor: textColor,
      textColor: textColor,
    );
  }

  Widget _buildPasswordTF() {
    final textColor = getContrastTextLight(Theme.of(context).backgroundColor);
    return passWordField(
      context: context,
      textColor: textColor,
      hintTextColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.white54
          : Colors.black54,
      labelColor: textColor,
      focusNode: focusPassword,
      onSaved: (String? value) {
        setState(() {
          form.setPassword(value ?? "");
        });
      },
      prefixIconColor: textColor,
    );
  }

  Widget _buildForgotPasswordBtn() {
    return Container(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: EdgeInsets.only(right: 0.0),
        child: TextButton(
          onPressed: () => Navigator.pushNamed(context, "/password-reset"),
          child: Text(
            "Forgot Password?",
            style: kLabelStyle(Theme.of(context).brightness == Brightness.dark),
          ),
        ),
      ),
    );
  }

  Widget _buildRememberMeCheckbox() {
    return Container(
      height: 20.0,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              value: form.remember,
              checkColor: Theme.of(context).indicatorColor,
              activeColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  form.setRemember(value);
                });
              },
            ),
          ),
          Text(
            "Remember me",
            style: kLabelStyle(Theme.of(context).brightness == Brightness.dark),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginBtn(AuthState authState) {
    return Button(
      context: context,
      onPressed: () => _login(authState),
      text: "LOGIN",
      loadingColor: Theme.of(context).indicatorColor,
      loading: authState.loadingStateUserLogin == LoadingState.loading,
    );
  }

  @override
  Widget build(BuildContext context) {
    final AuthState authState = Provider.of<AuthState>(context);
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                // color: Theme.of(context).brightness == Brightness.dark
                //     ? Colors.black87
                //     : Colors.white10,
                // decoration: backgroundDecor
              ),
              Container(
                height: double.infinity,
                child: Padding(
                  padding:
                      EdgeInsets.only(left: 40.0, right: 40.0, bottom: 20.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Text(
                                "Sign In",
                                style: TextStyle(
                                  color: getContrastTextLight(
                                      Theme.of(context).backgroundColor),
                                  // fontFamily: 'OpenSans',
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 30.0),
                              _buildEmailTF(),
                              SizedBox(
                                height: 30.0,
                              ),
                              _buildPasswordTF(),
                              _buildForgotPasswordBtn(),
                              _buildRememberMeCheckbox(),
                              _buildLoginBtn(authState),
                            ],
                          ),
                        ),
                      ),
                      CopyrightText()
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
