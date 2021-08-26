import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class TapToActionText extends StatelessWidget {
  const TapToActionText({
    Key? key,
    required this.label,
    required this.tapLabel,
    required this.onTap,
    this.padding = const EdgeInsets.only(top: 20),
  }) : super(key: key);

  final String? label;
  final String? tapLabel;
  final void Function()? onTap;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      width: double.infinity,
      child: Center(
        child: RichText(
          text: TextSpan(
            text: label,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xffB8AAA3),
            ),
            children: <TextSpan>[
              TextSpan(
                text: tapLabel,
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                recognizer: TapGestureRecognizer()..onTap = onTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
