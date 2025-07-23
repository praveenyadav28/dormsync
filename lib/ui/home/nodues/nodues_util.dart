import 'package:flutter/material.dart';

class CombinedTransaction {
  final String source;
  final String? date;
  final String? description;
  final double amount;
  final String effect;

  CombinedTransaction({
    required this.source,
    this.date,
    this.description,
    required this.amount,
    required this.effect,
  });
}

class SummaryRow extends StatelessWidget {
  final String label;
  final double value;
  final bool isBold;
  final Color? valueColor;

  const SummaryRow({
    Key? key,
    required this.label,
    required this.value,
    this.isBold = false,
    this.valueColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style:
                isBold
                    ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                    : const TextStyle(fontSize: 14),
          ),
          Text(
            '₹${value.abs().toStringAsFixed(2)} ${value < 0 ? "Cr" : "Dr"}',
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 16 : 14,
              color: valueColor ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
