import 'package:flutter/material.dart';

import 'floating_appbar_wrapper.dart';

class FloatingAppBarWrapperWithTextField extends StatelessWidget {
  const FloatingAppBarWrapperWithTextField({
    Key? key,
    required this.height,
    required this.width,
    required this.leadingIcon,
    this.onTapLeadingIcon,
    required this.hintLabel,
    this.controller,
    this.onSubmitted,
  }) : super(key: key);

  final double height;
  final double width;
  final IconData leadingIcon;
  final void Function()? onTapLeadingIcon;
  final String hintLabel;
  final TextEditingController? controller;
  final void Function(String)? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return FloatingAppBarWrapper(
      height: height,
      width: width,
      children: [
        IconButton(
          onPressed: onTapLeadingIcon,
          icon: Icon(
            leadingIcon,
            color: Color(0xffB8AAA3),
          ),
        ),
        Expanded(
          child: TextField(
            controller: controller,
            textInputAction: TextInputAction.send,
            onSubmitted: onSubmitted,
            decoration: InputDecoration(
              hintText: hintLabel,
              hintStyle: TextStyle(
                color: Color(0xffB8AAA3),
              ),
              border: InputBorder.none,
              prefixIconConstraints: BoxConstraints(
                maxHeight: 10,
                minHeight: 10,
                minWidth: 26,
                maxWidth: 34,
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
