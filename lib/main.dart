import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/services/theme_services.dart';
import 'package:todo_app/ui/screens/home_screenn.dart';

import 'ui/screens/notification_screen.dart';
import 'ui/themes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeServices().theme,
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}


