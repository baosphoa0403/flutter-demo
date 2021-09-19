import 'dart:ui';

import 'package:demoflutter/common_widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';

class SocialSignInButton extends ElevatedButtonCustom {
  SocialSignInButton(
      {Key? key,
      required String assertName,
      required String text,
      required Color color,
      required Color textColor,
      required VoidCallback? onPressed,
      required double borderRadius,
      required double height
      })
      : super(
            key: key,
            color: color,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(assertName, width: 30,height: 30,),
                Text(text, style:  TextStyle(color: textColor),),
                Opacity(opacity: 0.0,
                child: Image.asset(assertName, width: 30,height: 30,)),
              ],
            ),
            onPressed: onPressed,
            borderRadius: borderRadius,
            height: height
            );
}
