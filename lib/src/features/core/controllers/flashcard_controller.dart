import 'package:flutter/material.dart';

class ScreenRowAlphabet extends StatelessWidget {
  final AssetImage image1;
  final AssetImage image2;

  const ScreenRowAlphabet({
    required this.image1,
    required this.image2,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Image(image: image1),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Image(image: image2),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
      ],
    );
  }
}