import 'package:flutter/material.dart';
import 'package:omsnepal/utils/contrastTestColor.dart';

class CopyrightText extends StatelessWidget {
  const CopyrightText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        'Copyright 2021 \u00a9 OMS Nepal',
        style: TextStyle(
            color: getContrastTextLight(Theme.of(context).backgroundColor)),
      ),
    );
  }
}
