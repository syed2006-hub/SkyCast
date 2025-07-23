import 'package:flutter/material.dart';

class AdditoinalInfoWindow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const AdditoinalInfoWindow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 27),
        const SizedBox(height: 5),

        Text(label),
        const SizedBox(height: 5),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
