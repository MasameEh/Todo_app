import 'package:flutter/material.dart';
import 'package:todo_app/ui/themes.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({super.key, required this.label, required this.onTap});

  final String label;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: 45,
        width: 100,
        decoration: BoxDecoration(
          color: primaryClr,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
