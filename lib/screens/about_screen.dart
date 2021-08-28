import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);
  static const routeName = '/about';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Text(
            'About Screen',
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
      ),
    );
  }
}
