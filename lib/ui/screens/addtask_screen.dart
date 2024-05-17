import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/ui/themes.dart';
import 'package:todo_app/ui/widgets/inputfield.dart';

import '../../controllers/task_controller.dart';
import '../widgets/defaultbutton.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TaskController _taskController = Get.put(TaskController());

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  final DateTime _selectedDate = DateTime.now();

  final String _startTime =
      DateFormat('hh:mm a').format(DateTime.now()).toString();
  final String _endTime = DateFormat('hh:mm a')
      .format(DateTime.now().add(const Duration(minutes: 15)))
      .toString();

  final _selectedRemind = 5.obs;
  List<int> remindList = [5, 10, 15, 20];
  final _selectedRepeat = 'None'.obs;
  List<String> repeatList = ['None', 'Daily', 'Weekly', 'Monthly'];
  final _selectedColor = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _customAppBar(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Add Task',
                style: headingStyle,
              ),
              InputField(
                title: 'Title',
                hint: 'Enter Title here',
                controller: _titleController,
              ),
              InputField(
                title: 'Note',
                hint: 'Enter note here',
                controller: _noteController,
              ),
              InputField(
                title: 'Date',
                hint: DateFormat.yMd().format(_selectedDate),
                icon: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.calendar_today_outlined,
                      color: Colors.grey),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      title: 'Start Time',
                      hint: _startTime,
                      icon: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.access_time_rounded,
                            color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: InputField(
                      title: 'End Time',
                      hint: _endTime,
                      icon: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.access_time_rounded,
                            color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
              Obx(
                () => InputField(
                  title: 'Remind',
                  hint: '${_selectedRemind.value} minutes early',
                  icon: DropdownButton(
                    borderRadius: BorderRadius.circular(12),
                    items: remindList
                        .map((value) => DropdownMenuItem(
                              value: value,
                              child: Text(
                                '$value',
                                style: TextStyle(
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ))
                        .toList(),
                    onChanged: (remindValue) {
                      if (remindValue == null) {
                        return;
                      }
                      _selectedRemind.value = remindValue;
                    },
                    elevation: 4,
                    style: subTitleStyle,
                    underline: Container(height: 0.0),
                    iconSize: 32,
                    icon: const Icon(Icons.keyboard_arrow_down,
                        color: Colors.grey),
                  ),
                ),
              ),
              Obx(
                () => InputField(
                  title: 'Repeat',
                  hint: _selectedRepeat.value,
                  icon: DropdownButton(
                    borderRadius: BorderRadius.circular(12),
                    items: repeatList
                        .map((value) => DropdownMenuItem(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ))
                        .toList(),
                    onChanged: (repeatValue) {
                      if (repeatValue == null) {
                        return;
                      }
                        _selectedRepeat.value = repeatValue;
                    },
                    elevation: 4,
                    style: subTitleStyle,
                    underline: Container(height: 0.0),
                    iconSize: 32,
                    icon: const Icon(Icons.keyboard_arrow_down,
                        color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 18,),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _colorPalette(),
                    DefaultButton(
                      label: 'Create Task',
                      onTap: () {
                        Get.back();
                      },
                    ),
                  ]
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _customAppBar() => AppBar(
    leading: IconButton(
      onPressed: () {
        Get.back();
      } ,
      icon: const Icon(
          Icons.arrow_back_outlined,
          color: primaryClr,
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

  Column _colorPalette() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Color', style: titleStyle),
        const SizedBox(height: 10,),
        Obx(
          () => Wrap(
            children: List<Widget>.generate(
              3,
              (index) => GestureDetector(
                onTap: () {
                  _selectedColor.value = index;
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CircleAvatar(
                    backgroundColor: index == 0
                        ? primaryClr
                        : index == 1
                            ? pinkClr
                            : orangeClr,
                    child: _selectedColor.value == index
                        ? const Icon(
                            Icons.done,
                            size: 18,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
