import 'package:flutter/material.dart';

class Message extends StatelessWidget {
  final String message;
  final IconData icon;
  const Message({Key? key, required this.message, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
                padding: const EdgeInsets.only(bottom: 18.0),
                child: Icon(
                  icon,
                  size: 100,
                )),
            Text(message)
          ],
        ),
      ),
    );
  }
}
