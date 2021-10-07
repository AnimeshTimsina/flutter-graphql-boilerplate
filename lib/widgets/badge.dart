import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  final double top;
  final double right;
  final Widget child; // our Badge widget will wrap this child widget
  final Widget value; // what displays inside the badge
  final Color? color; // the  background color of the badge - default is red
  final bool show;
  const Badge({
    Key? key,
    required this.top,
    required this.right,
    required this.child,
    required this.value,
    required this.show,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        alignment: Alignment.center,
        children: [
          child,
          if (show == true)
            Positioned(
              right: right,
              top: top,
              child: Container(
                  padding: EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: color != null ? color : Colors.red,
                  ),
                  constraints: BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: value),
            )
        ],
      ),
    );
  }
}
