import 'package:flutter/material.dart';

class SideTabbedTitle extends StatelessWidget {
  const SideTabbedTitle(
    this.title, {
    Key? key,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          decoration: BoxDecoration(
            color: Color(0xffD1793F),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
          ),
          child: Text(
            title,
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
      ],
    );
  }
}
