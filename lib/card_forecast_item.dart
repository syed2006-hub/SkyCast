import 'package:flutter/material.dart';

class CardItemForecast extends StatelessWidget {
  final String time;
  final String temparature;
  final IconData icon;

  const CardItemForecast({
    super.key,
    required this.time,
    required this.temparature,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 105,
      child: Card(
        child: Padding(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: Column(
            children: [
              Text(
                time,
                style: TextStyle(fontSize: 22),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Icon(icon, size: 35),
              const SizedBox(height: 8),
              Text(temparature),
            ],
          ),
        ),
      ),
    );
  }
}
