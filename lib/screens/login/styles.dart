import 'package:flutter/material.dart';
import 'package:omsnepal/utils/contrastTestColor.dart';

kLabelStyle(bool isDark) => TextStyle(
      color: getContrastTextLight(isDark ? Colors.black : Colors.white),
      fontWeight: FontWeight.bold,
      // fontFamily: 'OpenSans',
    );
