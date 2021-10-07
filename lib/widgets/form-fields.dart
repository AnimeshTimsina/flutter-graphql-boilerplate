import 'package:flutter/material.dart';
import 'package:omsnepal/services/theme.dart';

class FormField extends StatefulWidget {
  final Color? labelColor;
  final Color? boxColor;
  final BuildContext context;
  final String label;
  final FocusNode? focusNode;
  final void Function(String?)? onSaved;
  final int maxLength;
  final Color? textColor;
  final String? hintText;
  final Color? hintTextColor;
  final bool hasNextField;
  final FocusNode? nextFocusNode;
  // final bool obscureText;
  final IconData? prefixIcon;
  final Color? prefixIconColor;
  final TextInputType? inputType;
  final String? Function(String?)? validator;
  final bool? isPassword;

  const FormField(
      {Key? key,
      this.labelColor,
      required this.context,
      this.boxColor,
      required this.label,
      this.focusNode,
      this.onSaved,
      this.textColor = Colors.white,
      this.maxLength = 50,
      this.hintText,
      this.hintTextColor,
      this.hasNextField = false,
      this.nextFocusNode,
      // this.obscureText = false,
      this.prefixIcon,
      this.prefixIconColor,
      this.inputType,
      this.validator,
      this.isPassword})
      : super(key: key);

  @override
  _FormFieldState createState() =>
      _FormFieldState(isObscure: isPassword == true ? true : false);
}

class _FormFieldState extends State<FormField> {
  bool isObscure;
  // bool _isObscure = this.isPassword == true ? true : false;

  _FormFieldState({required this.isObscure});

  @override
  Widget build(BuildContext context) {
    final kHintTextStyle = TextStyle(
      color: widget.hintTextColor != null
          ? widget.hintTextColor
          : Theme.of(context).brightness == Brightness.dark
              ? Colors.white54
              : Colors.black54,
      // fontFamily: 'OpenSans',
    );

    final kLabelStyle = TextStyle(
      color: widget.labelColor != null
          ? widget.labelColor
          : Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black,
      fontWeight: FontWeight.bold,
      // fontFamily: 'OpenSans',
    );

    final kBoxDecorationStyle = BoxDecoration(
      // color: widget.boxColor != null ? widget.boxColor : PRIMARY_BACKGROUND,
      // color: Color(0xee1fb8a5),
      borderRadius: BorderRadius.circular(10.0),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 6.0,
          offset: Offset(0, 2),
        ),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          widget.label,
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
              focusNode: widget.focusNode,
              keyboardType: widget.inputType,
              textInputAction:
                  widget.hasNextField ? TextInputAction.next : null,
              onFieldSubmitted: widget.nextFocusNode != null
                  ? (_) {
                      FocusScope.of(context).requestFocus(widget.nextFocusNode);
                    }
                  : null,
              onSaved: (String? val) => widget.onSaved!(val),
              obscureText: isObscure,
              maxLength: widget.maxLength,
              style: TextStyle(
                color: widget.textColor,
                // fontFamily: 'OpenSans',
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                errorStyle: TextStyle(height: 0),
                contentPadding: EdgeInsets.only(top: 14.0),
                counter: Offstage(),
                prefixIcon: widget.prefixIcon != null
                    ? Icon(
                        widget.prefixIcon,
                        color: widget.prefixIconColor != null
                            ? widget.prefixIconColor
                            : Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black,
                      )
                    : null,
                suffixIcon: widget.isPassword == true
                    ? IconButton(
                        icon: Icon(isObscure
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            isObscure = !isObscure;
                          });
                        })
                    : null,
                hintText: widget.hintText,
                hintStyle: kHintTextStyle,
              ),
              validator: widget.validator != null
                  ? widget.validator
                  : (value) {
                      if (value == null || value.isEmpty) {
                        return '';
                      }
                      return null;
                    }),
        ),
      ],
    );
  }
}

Widget passWordField({
  required BuildContext context,
  String? label,
  FocusNode? focusNode,
  FocusNode? nextFocusNode,
  String? hintText,
  Color? textColor,
  Color? hintTextColor,
  Color? boxColor,
  Color? labelColor,
  Color? prefixIconColor,
  void Function(String?)? onSaved,
}) =>
    FormField(
      context: context,
      label: label ?? "Password",
      maxLength: 40,
      focusNode: focusNode,
      hasNextField: nextFocusNode != null ? true : false,
      nextFocusNode: nextFocusNode,
      hintText: hintText != null ? hintText : "Enter your password",
      // obscureText: true,
      prefixIcon: Icons.lock,
      hintTextColor: hintTextColor,
      boxColor: boxColor,
      labelColor: labelColor,
      prefixIconColor: prefixIconColor,
      textColor: textColor,
      isPassword: true,
      onSaved: onSaved,
    );

Widget usernameField({
  required BuildContext context,
  String? label,
  FocusNode? focusNode,
  FocusNode? nextFocusNode,
  String? hintText,
  Color? textColor,
  Color? hintTextColor,
  Color? boxColor,
  Color? labelColor,
  Color? prefixIconColor,
  void Function(String?)? onSaved,
}) =>
    FormField(
      context: context,
      label: label ?? "Username",
      maxLength: 40,
      focusNode: focusNode,
      hasNextField: nextFocusNode != null ? true : false,
      nextFocusNode: nextFocusNode,
      hintText: hintText ?? "Enter your username",
      // obscureText: false,
      prefixIcon: Icons.account_circle,
      hintTextColor: hintTextColor,
      boxColor: boxColor,
      labelColor: labelColor,
      prefixIconColor: prefixIconColor,
      textColor: textColor,
      inputType: TextInputType.text,
      onSaved: onSaved,
    );

Widget emailField({
  required BuildContext context,
  String? label,
  FocusNode? focusNode,
  FocusNode? nextFocusNode,
  String? hintText,
  Color? textColor,
  Color? hintTextColor,
  Color? boxColor,
  Color? labelColor,
  Color? prefixIconColor,
  void Function(String?)? onSaved,
}) =>
    FormField(
      context: context,
      inputType: TextInputType.emailAddress,
      label: label ?? "Email",
      maxLength: 50,
      focusNode: focusNode,
      hasNextField: nextFocusNode != null ? true : false,
      nextFocusNode: nextFocusNode,
      hintText: hintText ?? "Enter your email",
      // obscureText: false,
      prefixIcon: Icons.email,
      hintTextColor: hintTextColor,
      boxColor: boxColor,
      labelColor: labelColor,
      prefixIconColor: prefixIconColor,
      textColor: textColor,
      onSaved: onSaved,
      validator: (String? value) {
        if (value != null) {
          Pattern pattern =
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
          RegExp regex = new RegExp(pattern as String);
          if (!regex.hasMatch(value))
            return '';
          else
            return null;
        } else
          return '';
      },
    );
