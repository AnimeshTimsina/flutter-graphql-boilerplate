import 'package:flutter/material.dart';

class SecondaryAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(70);

  const SecondaryAppBar(
      {Key? key,
      required Color textColor,
      required Color bgColor,
      IconData? actionIcon,
      Function? actionClick})
      : _textColor = textColor,
        _bgColor = bgColor,
        _actionClick = actionClick,
        _actionIcon = actionIcon,
        super(key: key);

  final Color _textColor;
  final Color _bgColor;
  final IconData? _actionIcon;
  final Function? _actionClick;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      leading: Builder(
          builder: (context) => IconButton(
              icon: Icon(Icons.arrow_back_ios, color: _textColor),
              onPressed: () {
                Navigator.of(context).pop();
              })),
      backgroundColor: _bgColor,
      actions: [
        if (_actionIcon != null)
          IconButton(
            onPressed: () {
              if (_actionClick != null) _actionClick!();
            },
            icon: Icon(
              _actionIcon,
              color: _textColor,
              size: 30,
            ),
          )
      ],
    );
  }
}
