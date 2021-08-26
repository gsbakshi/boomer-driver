import 'package:flutter/material.dart';

class IconCard extends StatelessWidget {
  const IconCard({
    Key? key,
    required this.icon,
    required this.label,
    this.onTapHandler,
  }) : super(key: key);

  final IconData icon;
  final String label;
  final void Function()? onTapHandler;
  final borderRadius = 8.0;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Material(
          color: Color(0xffB8AAA3),
          elevation: 3,
          borderRadius: BorderRadius.circular(borderRadius),
          shadowColor: Theme.of(context).primaryColorDark,
          child: InkWell(
            onTap: onTapHandler,
            borderRadius: BorderRadius.circular(borderRadius),
            splashColor: Theme.of(context).primaryColorLight,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    color: Color(0xff6D5D54),
                  ),
                  SizedBox(height: 4),
                  Text(
                    label,
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
