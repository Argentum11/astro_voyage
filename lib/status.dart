import 'package:flutter/material.dart';

class CircularProgressWithTitle extends StatelessWidget {
  const CircularProgressWithTitle({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(
          height: 20,
        ),
        Text('$title...'),
      ],
    );
  }
}
