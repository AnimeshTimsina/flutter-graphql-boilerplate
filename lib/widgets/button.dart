import 'package:flutter/material.dart';
import 'package:omsnepal/services/theme.dart';

class Button extends StatelessWidget {
  final BuildContext context;
  final bool loading;
  final Function onPressed;
  final Color? textColor;
  final Color? loadingColor;
  final Color? backgroundColor;
  final String text;

  const Button({
    Key? key,
    required this.context,
    this.loading = false,
    required this.onPressed,
    this.textColor,
    this.loadingColor,
    this.backgroundColor,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: !loading ? double.infinity : null,
      child: loading
          ? CircularProgressIndicator.adaptive(
              valueColor: AlwaysStoppedAnimation<Color?>(loadingColor != null
                  ? loadingColor
                  : Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black))
          : ElevatedButton(
              style: ButtonStyle(
                  elevation: MaterialStateProperty.all(5.0),
                  padding: MaterialStateProperty.all(EdgeInsets.only(
                      left: 20.0, right: 20.0, top: 15.0, bottom: 15.0)),
                  backgroundColor: MaterialStateColor.resolveWith(
                      (states) => backgroundColor ?? Colors.white),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ))),
              onPressed: onPressed as void Function()?,
              child: Text(
                text,
                style: TextStyle(
                  color: textColor ?? Theme.of(context).indicatorColor,
                  letterSpacing: 1.0,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  // fontFamily: 'OpenSans',
                ),
              ),
            ),
    );
  }
}
