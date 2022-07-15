import 'package:flutter/material.dart';

import '../../domain/entities/number_trivia.dart';

class TriviaDisplay extends StatelessWidget {
  final NumberTrivia numberTrivia;

  const TriviaDisplay({
    required this.numberTrivia,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      child: Center(
        child: SingleChildScrollView(
            child: Column(
          children: [
            Text(numberTrivia.number.toString(),
                style:
                    const TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
            Text(numberTrivia.text,
                style: const TextStyle(
                  fontSize: 25,
                ),
                textAlign: TextAlign.center),
          ],
        )),
      ),
    );
  }
}
