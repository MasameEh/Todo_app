import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/services/theme_services.dart';
import 'package:todo_app/ui/widgets/defaultbutton.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/ui/widgets/task_tile.dart';

import '../../controllers/task_controller.dart';
import '../../models/task.dart';
import '../../services/notification_services.dart';
import '../size_config.dart';
import '../themes.dart';
import 'addtask_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin{

  final TaskController _taskController = Get.put(TaskController());
  final _selectedDate = DateTime.now().obs;

  late Animation<double> opacity;
  late AnimationController controller;

  late NotifyHelper notifyHelper;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 3000));

    opacity = Tween<double>(begin: 0, end: 1).animate(controller);
    controller.forward();

    notifyHelper = NotifyHelper();
    notifyHelper.requestIOSPermissions();
    notifyHelper.initNotification();
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _startAnimation() {
    controller.reset();
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    _startAnimation();

    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _customAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _addTaskBar(),
            Obx(() => _addDateBar()),
            TaskTile(
                Task(
                title: 'Title 1',
                color: 1,
                startTime: '2:10',
                endTime: '3:10',
                note: 'NOTE SOMETHING',
                isCompleted: 0,
              )
            ),
          ],
        ),
      ),
    );
  }

  _showTasks()
  {
    return Expanded(
        child: Obx(()
        {
          if(_taskController.taskList.isEmpty)
          {
            return _noTaskMsg();
          }
          else
          {
            return Container(height: 0,);
          }
        }
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

  _addDateBar() =>  Container(
    margin: const EdgeInsets.only(left: 20, top: 8),
    child:  DatePicker(DateTime.now(),
      initialSelectedDate: _selectedDate.value,
      width: 70,
      height: 100,
      selectedTextColor:Colors.white,
      dateTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          )
      ),
      dayTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          )
      ),
      monthTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          )
      ),
      selectionColor: primaryClr,
      onDateChange: (newDate)
      {
        _selectedDate.value = newDate;
        print(_selectedDate.value );
      },
    ),
  );

  _noTaskMsg()
  {
    return Stack(
      children:[ AnimatedPositioned(
        duration: const Duration(milliseconds: 2000),
        child: SingleChildScrollView(
          child: Wrap(
            direction: SizeConfig.orientation ==  Orientation.landscape ? Axis.horizontal:Axis.vertical,
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children:
             [
               SizeConfig.orientation ==  Orientation.landscape ? const SizedBox(height: 10,) : const SizedBox(height: 150,),
               FadeTransition(
                 opacity: opacity,
                 child: SvgPicture.asset('images/task.svg',
                  height: 80,
                  color: primaryClr.withOpacity(0.7),
                  semanticsLabel: 'Task',
                ),
               ),
               FadeTransition(
                 opacity: opacity,
                 child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  child: Text('You don\'t have any task yet!\nAdd new tasks to make your day productive.',
                  style: subTitleStyle,
                  textAlign: TextAlign.center
                  ),
                ),
              ),

            ],
          ),
        ),
      ),]
    );
  }

  AppBar _customAppBar() => AppBar(
    leading: IconButton(
      onPressed: () {
        ThemeServices().switchTheme();
        notifyHelper.displayNotification(title: 'Theme Changed', body: 'NOW');
        notifyHelper.scheduledNotification();
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
