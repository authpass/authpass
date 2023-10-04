import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
              margin: EdgeInsets.only(right: 20),
              height: 32,
              width: 39,
              decoration: BoxDecoration(
                border: Border.all(color: Color.fromRGBO(5, 114, 236,1), width: 0.5),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: Text('Edit', style: TextStyle(color: Color.fromRGBO(5, 114, 236,1)),),
              ),
            );
  }
}

