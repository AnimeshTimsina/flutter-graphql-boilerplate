import 'package:flutter/material.dart';

class PageTitle extends StatelessWidget {
  final String title;
  final IconData? icon;
  const PageTitle({Key? key, required this.title, this.icon}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final bool _isDark = Theme.of(context).brightness == Brightness.dark;
    final Color _textColor = _isDark ? Colors.white : Colors.grey.shade800;
    return Row(
      children: [
        Text(title, style: Theme.of(context).textTheme.headline4),
        if (icon != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(
              icon,
              color: Theme.of(context).accentColor,
            ),
          )
      ],
    );
    ;
  }
}
