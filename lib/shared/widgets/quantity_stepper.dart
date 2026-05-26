import 'package:flutter/material.dart';

class QuantityStepper extends StatelessWidget {
  const QuantityStepper({
    super.key,
    required this.value,
    required this.onDecrement,
    required this.onIncrement,
    this.min = 1,
    this.max = 99,
  });

  final int value;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final int min;
  final int max;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton.filled(
          onPressed: value > min ? onDecrement : null,
          icon: const Icon(Icons.remove),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            '$value',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        IconButton.filled(
          onPressed: value < max ? onIncrement : null,
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
