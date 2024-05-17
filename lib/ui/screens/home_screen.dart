import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/services/theme_services.dart';
import 'package:todo_app/ui/screens/notification_screen.dart';
import 'package:todo_app/ui/widgets/defaultbutton.dart';
import 'package:intl/intl.dart';

import '../themes.dart';
import 'addtask_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _customAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _addTaskBar(),
          ],
        ),
      ),
    );
  }

   _addTaskBar() {
     return Container(
       margin: const EdgeInsets.only(left: 20, top: 10, right: 10),
       child: Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
         children: [
           Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
                Text(DateFormat.yMMMMd().format(DateTime.now()),
                    style: subHeadingStyle,
                ),
                Text('Today',
                    style: headingStyle,
                ),
             ],
           ),
           DefaultButton(
               label: '+ Add Task',
               onTap: () async{
                  await Get.to(const AddTaskScreen());
                }),
         ],
       ),
     );
  }

  AppBar _customAppBar() => AppBar(
    leading: IconButton(
      onPressed: () {
        ThemeServices().switchTheme();
      } ,
      icon:  Icon(
          Get.isDarkMode ?
           Icons.wb_sunny_outlined
          :Icons.nightlight_round_outlined,
        color: Get.isDarkMode ? Colors.white : darkGreyClr,
        size: 24,
      ),
    ),
    elevation: 0,
    backgroundColor: context.theme.backgroundColor,
    actions: const [
      CircleAvatar(
        backgroundImage: AssetImage('images/person.jpeg'),
        radius: 18,
      ),
      SizedBox(width: 20,),
    ],
  );
}
