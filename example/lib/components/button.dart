import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;

  const Button({Key? key, required this.title, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4.0),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          title,
          style: const TextStyle(fontSize: 25),
        ),
      ),
    );
  }
}