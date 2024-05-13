import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'ui/screens/notification_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.teal,
        backgroundColor: Colors.teal,

        useMaterial3: true,
      ),
      home: const NotificationScreen(payload: 'asfdaas|fdas|sa'),
    );
  }
}


