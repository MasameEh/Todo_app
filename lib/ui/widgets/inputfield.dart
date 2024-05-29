import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/ui/size_config.dart';

import '../themes.dart';

class InputField extends StatelessWidget {
  const InputField({super.key, required this.title, required this.hint, this.controller, this.icon, this.validator});

  final String title;
  final String hint;

  final TextEditingController? controller;
  final Widget? icon;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {

    SizeConfig().init(context);
    return Container(
        margin: const EdgeInsets.only(top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: titleStyle,
            ),
            Container(
              padding: const EdgeInsets.only(left: 14),
              margin: const EdgeInsets.only(top: 8),
              height: 52,
              width: SizeConfig.screenWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: Colors.grey
                ),
              ),
              child: Row(
                children: [
                    Expanded(
                        child: TextFormField(
                          controller: controller,
                          autofocus: false,
                          cursorColor: Get.isDarkMode? Colors.grey[100]:Colors.grey[700],
                          validator: validator,
                          keyboardType: TextInputType.text,
                          readOnly: icon != null ? true: false,
                          decoration: InputDecoration(
                            hintStyle: subTitleStyle,
                            hintText: hint,
                            border: InputBorder.none,
                          //   enabledBorder: UnderlineInputBorder(
                          //     borderSide: BorderSide(
                          //       color: context.theme.backgroundColor,
                          //       width: 0,
                          //     ),
                          //   ),
                          //   focusedBorder:UnderlineInputBorder(
                          //     borderSide: BorderSide(
                          //       color: context.theme.backgroundColor,
                          //       width: 0,
                          //     ),
                          // ),
                        ),
                      ),
                    ),
                    icon ?? Container(),
                ],
              ),
            ),
          ],
        ),

    );
  }
}
