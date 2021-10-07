import 'package:flutter/material.dart';
import 'package:omsnepal/widgets/widgets.dart';

class RefetchMessage extends StatelessWidget {
  final String? message;
  final IconData? icon;
  final Function callback;
  const RefetchMessage(
      {Key? key, this.message, this.icon, required this.callback})
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
                  icon ?? Icons.error,
                  size: 100,
                )),
            Text(message ?? 'Something went wrong'),
            SizedBox(height: 5),
            Button(context: context, onPressed: callback, text: 'Retry')
          ],
        ),
      ),
    );
  }
}
