import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../themes.dart';

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
            onPressed: () => Get.back(),
            icon: Icon(Icons.arrow_back_outlined, color: Get.isDarkMode ? Colors.white: darkGreyClr),
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
            const SizedBox(height: 10,),
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
            const SizedBox(height: 10,),
            Expanded(
              child: Container(
                padding:  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                margin: const EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                  color: primaryClr,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.title,
                          color: Colors.white, size: 35,
                          ),
                          SizedBox(width: 20,),
                          Text(
                            'Title',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20,),
                      Text(
                        _payload.toString().split('|')[0],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 20,),
                      const Row(
                        children: [
                          Icon(Icons.description,
                            color: Colors.white, size: 35,
                          ),
                          SizedBox(width: 20,),
                          Text(
                            'Description',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20,),
                      Text(
                        _payload.toString().split('|')[1],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 20,),
                      const Row(
                        children: [
                          Icon(Icons.date_range_outlined,
                            color: Colors.white, size: 35,
                          ),
                          SizedBox(width: 20,),
                          Text(
                            'Date',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20,),
                      Text(
                        _payload.toString().split('|')[2],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 20,),
                    ],

                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
