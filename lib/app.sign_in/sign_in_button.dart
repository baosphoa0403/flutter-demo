import 'dart:ui';

import 'package:demoflutter/common_widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';

class SignInButton extends ElevatedButtonCustom {
  SignInButton(
      {Key? key,
      required String text,
      required Color color,
      required Color textColor,
      required VoidCallback? onPressed,
      required double borderRadius,
      required double height})
      : super(
            key: key,
            color: color,
            child: Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 15.0,
              ),
            ),
            onPressed: onPressed,
            borderRadius: borderRadius,
            height: height);
}
