import 'package:flutter/material.dart';

class PercentageIndicator2 extends StatelessWidget {
  final int percent ;
  const PercentageIndicator2({super.key, required this.percent});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      width: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3)
      ),
      child: Center(
        child: Container(
          height: 5,
          width: 100,
          color: const Color.fromARGB(255, 225, 226, 225),
          child: Row(
            children: [
              Expanded(
                flex: percent,
                child: Container(
                  height: 5,
                  decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: Colors.green,
      ),
                  
                ),
              ),
              Expanded(
                flex: 100 - percent,
                child: Container(
                  decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: const Color.fromARGB(255, 193, 194, 193),
      ),
                  height: 5,
                  
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
