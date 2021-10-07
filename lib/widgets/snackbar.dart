import 'package:flutter/material.dart';
import 'package:omsnepal/utils/contrastTestColor.dart';

SnackBar snackbar(
    {required String text, Color color = Colors.green, int timeInSeconds = 2}) {
  return SnackBar(
    content: Text(
      text,
      style: TextStyle(color: getContrastText(color)),
    ),
    duration: Duration(seconds: timeInSeconds),
    backgroundColor: color,
  );
}
