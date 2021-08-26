import 'package:flutter/material.dart';

import '../widgets/splashed_flex.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  static const routeName = '/splash';

  @override
  Widget build(BuildContext context) {
    var query = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Stack(
          fit: StackFit.expand,
          children: [
            SplashedFlex(),
            Positioned(
              bottom: 0,
              child: Container(
                height: query.height * 0.2,
                width: query.width,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
