import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
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
      body: Column(
          children: [
            _addTaskBar(),
            Obx(() => _addDateBar()),
             _showTasks(),
          ],
        ),
    );
  }

  _showTasks()
  {
    return Expanded(
      child: ListView.builder(
          scrollDirection: SizeConfig.orientation == Orientation.landscape
              ? Axis.horizontal
              : Axis.vertical,
          itemBuilder: (context, index) {
            var task = _taskController.taskList[index];
            print(_taskController.taskList.length);
            try {
              // Assuming task.startTime is in the format 'hh:mm a' (12-hour format with AM/PM)
              var dateFormat = DateFormat('hh:mm a');
              var dateTime = dateFormat.parse(task.startTime!);

              var hour = dateTime.hour;
              var minutes = dateTime.minute;

              debugPrint('MY TIME IS $hour');
              debugPrint('MY TIME IS $minutes');

              // Assuming you have a notifyHelper instance to schedule notifications
              notifyHelper.scheduledNotification(hour, minutes, task);
            } catch (e) {
              debugPrint('Error parsing time: $e');
            }
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 1300),
              child: SlideAnimation(
                horizontalOffset: 300.0,
                child: FadeInAnimation(
                  child: GestureDetector(
                    onTap: (){
                      showBottomSheet(context, task);
                    },
                    child: TaskTile(task),
                  ),
                ),
              ),
            );
          },
        itemCount: _taskController.taskList.length,
      ),
    );
    // return Expanded(
    //     child: Obx(()
    //     {
    //       if(_taskController.taskList.isEmpty)
    //       {
    //         return _noTaskMsg();
    //       }
    //       else
    //       {
    //         return Container(height: 0,);
    //       }
    //     }
    //     ),
    // );
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

  showBottomSheet(BuildContext ctx, Task task)
  {
    Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(
            top: 4,
          ),
          width: SizeConfig.screenWidth,
          height: SizeConfig.orientation == Orientation.landscape ?
                  (task.isCompleted == 1? SizeConfig.screenHeight * 0.6 : SizeConfig.screenHeight * 0.5)
                  :(task.isCompleted == 1? SizeConfig.screenHeight * 0.3 : SizeConfig.screenHeight * 0.39),
          color: Get.isDarkMode ? darkHeaderClr : Colors.white,
          child: Column(
            children: [
              Flexible(
                  child: Container(
                    height: 8,
                    width: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Get.isDarkMode
                          ? Colors.grey[600]
                          : Colors.grey[300],
                    ),
                  ),
              ),
              const SizedBox(height: 10,),
              task.isCompleted == 1
                  ? Container()
                  : _buildBottomSheet(
                      label: 'Task Completed',
                      clr: primaryClr,
                      onTap: (){
                        Get.back();
                      },
                  ),
              _buildBottomSheet(
                label: 'Delete Task',
                clr: primaryClr,
                onTap: (){
                  Get.back();
                },
              ),
              Divider(color: Get.isDarkMode ? Colors.grey : darkGreyClr,),
              _buildBottomSheet(
                label: 'Cancel',
                clr: primaryClr,
                onTap: (){
                  Get.back();
                },
              ),
              const SizedBox(height: 20,),
            ],
          ),
        ),
      ),
    );
  }

  _buildBottomSheet({required String label,
                    required Function() onTap,
                    required Color clr,
                    bool isClose = false})
  {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 65,
        width: SizeConfig.screenWidth * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose
                ? Get.isDarkMode
                  ? Colors.grey[600]!
                  : Colors.grey[300]!
                : clr,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose ? Colors.transparent : clr,
        ),
        child: Center(
          child: Text(
              label,
              style: titleStyle.copyWith(
                  color: Colors.white
              )
          ),
        ),
      ),
    );
  }
}
