import 'package:flutter/material.dart';

import 'decorated_wrapper.dart';

class FloatingAppBarWrapper extends StatelessWidget {
  const FloatingAppBarWrapper({
    Key? key,
    this.children = const <Widget>[],
    required this.height,
    required this.width,
  }) : super(key: key);

  final List<Widget> children;
  final double height;
  final double width;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: height,
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: DecoratedWrapper(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}
