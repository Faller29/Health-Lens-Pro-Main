import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            IconlyLight.chart,
            size: 120,
            color: Colors.black,
          ),
          Text(
            'Analytics Page',
            style: TextStyle(
                color: Colors.black, fontSize: 30, fontWeight: FontWeight.w700),
          )
        ],
      ),
    );
  }
}
