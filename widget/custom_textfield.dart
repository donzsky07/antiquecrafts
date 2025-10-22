import 'package:projects/consts/consts.dart';
import 'package:flutter/material.dart';

Widget customTextField({
  String? title,
  String? hint,
  controller,
  bool isPass = false,
}) {
  // Local ValueNotifier to handle visibility toggle
  final ValueNotifier<bool> _isHidden = ValueNotifier<bool>(isPass);

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      title!.text.color(redColor).fontFamily(semibold).size(16).make(),
      5.heightBox,

      // TextFormField wrapped in ValueListenableBuilder to listen for toggle
      ValueListenableBuilder<bool>(
        valueListenable: _isHidden,
        builder: (context, value, child) {
          return TextFormField(
            obscureText: value,
            controller: controller,
            decoration: InputDecoration(
              hintStyle: const TextStyle(
                fontFamily: semibold,
                color: textfieldGrey,
              ),
              hintText: hint,
              isDense: true,
              fillColor: lightGrey,
              filled: true,
              border: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: redColor),
              ),
              // 👁️ Eye Icon only when isPass is true
              suffixIcon: isPass
                  ? IconButton(
                      icon: Icon(
                        value ? Icons.visibility_off : Icons.visibility,
                        color: textfieldGrey,
                      ),
                      onPressed: () {
                        _isHidden.value = !_isHidden.value;
                      },
                    )
                  : null,
            ),
          );
        },
      ),
      5.heightBox,
    ],
  );
}
