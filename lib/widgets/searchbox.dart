import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget {
  final Color? backgroundColor;
  final Color? textColor;
  final TextEditingController controller;
  final String? placeholder;
  const SearchBox(
      {Key? key,
      this.backgroundColor,
      this.textColor,
      required this.controller,
      this.placeholder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool _isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
        color: backgroundColor ?? Colors.grey.withOpacity(0.4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
                top: 8.0, bottom: 8.0, left: 20.0, right: 10.0),
            child: Icon(
              Icons.search,
              color: textColor ?? Colors.white.withOpacity(0.9),
            ),
          ),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                  suffixIcon: controller.text.length == 0
                      ? null // Show nothing if the text field is empty
                      : IconButton(
                          color: Colors.white,
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            controller.clear();
                          },
                        ),
                  border: InputBorder.none,
                  hintText: placeholder,
                  hintStyle: TextStyle(
                      color: textColor ?? Colors.white.withOpacity(0.9),
                      fontSize: 14)),
              controller: controller,
              style:
                  TextStyle(color: textColor ?? Colors.white.withOpacity(0.9)),
            ),
          )
        ],
      ),
    );
  }
}
