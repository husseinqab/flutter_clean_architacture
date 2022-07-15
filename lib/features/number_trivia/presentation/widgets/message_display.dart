import 'package:flutter/material.dart';

class MessageDisplay extends StatelessWidget {
  final String text;

  const MessageDisplay({
    required this.text,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      child: Center(
        child: SingleChildScrollView(
          child: Text(text,
              style: const TextStyle(
                fontSize: 25,
              ),
              textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
