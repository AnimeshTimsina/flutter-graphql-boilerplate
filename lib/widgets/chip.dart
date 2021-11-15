import 'package:flutter/material.dart';

class CustomChip extends StatelessWidget {
  final bool isActive;
  final String text;
  final Function? onTap;
  final bool? isSmall;
  const CustomChip(
      {Key? key,
      required this.isActive,
      required this.text,
      this.onTap,
      this.isSmall})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool _isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ActionChip(
          shadowColor: Colors.transparent,
          onPressed: () {
            if (onTap != null) onTap!();
          },
          side: BorderSide(
              color: Theme.of(context).indicatorColor.withOpacity(0.2)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          label: Text(
            text,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: (isSmall != null && isSmall == true) ? 13 : null,
                color: isActive
                    ? Colors.white
                    : (_isDark ? Colors.white70 : Colors.grey.shade700)),
          ),
          elevation: isActive ? 20 : 0,
          backgroundColor: isActive
              ? Theme.of(context).indicatorColor
              : Theme.of(context).indicatorColor.withOpacity(0.1)),
    );
  }
}
