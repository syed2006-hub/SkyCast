import 'package:flutter/material.dart';

class CloudProgressIndicator extends StatelessWidget {
  const CloudProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 100,
            height: 100,
            child: CircularProgressIndicator(
              strokeWidth: 6,
              backgroundColor: Colors.blue[100],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ),
          Icon(Icons.cloud, size: 50, color: Colors.blueGrey.shade300),
        ],
      ),
    );
  }
}
