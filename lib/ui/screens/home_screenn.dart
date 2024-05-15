import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/services/theme_services.dart';
import 'package:todo_app/ui/screens/notification_screen.dart';

import '../themes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            ThemeServices().switchTheme();
            Get.to(const NotificationScreen(payload: 'Title | Description | 20:10:2010'));
          } ,
          icon: Icon(Icons.arrow_back_outlined, color: Get.isDarkMode ? Colors.white: darkGreyClr),
        ),
      ),
      body: Container(),
    );
  }
}
