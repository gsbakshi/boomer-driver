import 'package:flutter/material.dart';

class RatingsScreen extends StatelessWidget {
  const RatingsScreen({Key? key}) : super(key: key);
  static const routeName = '/ratings-screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Text(
            'Ratings Screen',
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
      ),
    );
  }
}
