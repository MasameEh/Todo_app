import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key, required this.payload});

   final String payload;

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String _payload = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _payload = widget.payload;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Get.back,
            icon: const Icon(Icons.arrow_back_outlined),
        ),
        backgroundColor: context.theme.backgroundColor,
        elevation: 0.0,
        title: Text(
            _payload.toString().split('|')[0],
          style: TextStyle(
            color: Get.isDarkMode ? Colors.white: darkGreyClr,
          )
        ),
        centerTitle: true,
      ),
      body: SafeArea
        (
        child: Column(
          children: [
            Text('Hello, 3mi',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 26,
                  color: Get.isDarkMode ? Colors.white: darkGreyClr,
                )
            ),
            const SizedBox(height: 10,),
            Text('You have a new reminder',
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 18,
                  color: Get.isDarkMode ? Colors.grey[100]: darkGreyClr,
                )
            ),
          ],
        ),
      ),
    );
  }
}
