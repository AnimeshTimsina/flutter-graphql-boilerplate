import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:omsnepal/graphql/custom_types/error.dart';
import 'package:omsnepal/graphql/models/bool_response.dart';
import 'package:omsnepal/graphql/mutations/passwordReset.dart';
import 'package:omsnepal/services/client.dart';
import 'package:omsnepal/services/theme.dart';
import 'package:omsnepal/utils/contrastTestColor.dart';
import 'package:omsnepal/widgets/widgets.dart';

class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({Key? key}) : super(key: key);

  @override
  _PasswordResetScreenState createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _email;
  bool _loading = false;

  _disableLoading() => setState(() {
        _loading = false;
      });

  _enableLoading() => setState(() {
        _loading = true;
      });

  _showError(String msg) {
    if (_loading = true) {
      _disableLoading();
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(snackbar(text: msg, color: Colors.red));
    _formKey.currentState!.reset();
  }

  _success() {
    ScaffoldMessenger.of(context).showSnackBar(
        snackbar(text: 'Password Reset has been sent to your email'));
    Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
  }

  _sendEmail() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Map payload = {"query": gqlPasswordReset(_email!)};
      _enableLoading();
      final Response? response = await http
          .post(
            Uri.parse(ENDPOINT),
            headers: <String, String>{
              'Content-Type': 'application/json',
            },
            body: jsonEncode(payload),
          )
          .catchError((onError) {});
      _disableLoading();
      if (response?.body != null) {
        Map<String, dynamic> incoming = json.decode(response!.body);
        if (incoming["errors"] != null ||
            incoming["data"]["sendPasswordResetMail"] == null) {
          if (incoming["errors"] != null) {
            List<ErrorModel> errors = List.generate(incoming["errors"].length,
                (index) => ErrorModel.fromJson(incoming["errors"][index]));
            if (errors.length > 0 && errors.first.message != null) {
              _showError(errors.first.message!);
            }
          }
          print('error');
        } else {
          try {
            BoolResponse output = BoolResponse.fromJson(
                incoming["data"]["sendPasswordResetMail"]);
            if (output.ok == true) {
              _success();
            } else {
              _showError('Something went wrong!');
            }
          } catch (error) {
            _showError('Something went wrong!');
          }
        }
      } else {
        _showError('Something went wrong!');
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(snackbar(text: 'Enter valid email', color: Colors.red));
    }
  }

  Widget _buildEmailTF() {
    return emailField(
      context: context,
      label: 'Registered email',
      onSaved: (String? value) {
        setState(() {
          _email = value;
        });
      },
      // textColor: Colors.white,
      // labelColor: Colors.white,
      // prefixIconColor: Colors.white,
      // hintTextColor: Colors.white54,
    );
  }

  Widget _buildResetBtn() {
    return Button(
      context: context,
      onPressed: _sendEmail,
      text: 'Send Reset Link',
      loading: _loading,
      loadingColor: PRIMARY_BACKGROUND,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Forgot Password',
            style: TextStyle(fontFamily: GoogleFonts.mcLaren().fontFamily),
          ),
          // backgroundColor: PRIMARY_BACKGROUND,
          elevation: 0.0,
        ),
        body: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
            ),
            Container(
              height: double.infinity,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: 30.0,
                  vertical: 30.0,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _buildEmailTF(),
                      SizedBox(
                        height: 5.0,
                      ),
                      _buildResetBtn(),
                      Text(
                        'A password reset link will be sent to your registered email address. Open the link and follow accordingly to reset your password.',
                        style: TextStyle(
                          fontSize: 12,
                          color: getContrastTextLight(
                              Theme.of(context).backgroundColor),
                        ),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
