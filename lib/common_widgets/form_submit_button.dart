import 'package:demoflutter/common_widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';

class FormSubmitButton extends ElevatedButtonCustom {
  FormSubmitButton({Key? key, required String text, VoidCallback? onPressed})
      : super(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 20.0),
            ),
            height: 44.0,
            color: Colors.indigo,
            borderRadius: 4.0,
            onPressed: onPressed);
}
