import 'package:flutter/material.dart';

class SplashedFlex extends StatelessWidget {
  const SplashedFlex({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Image(image: AssetImage('assets/logo/cover.png')),
        Text(
          'Driver App',
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontFamily: 'Viga',
          ),
        ),
      ],
    );
  }
}
