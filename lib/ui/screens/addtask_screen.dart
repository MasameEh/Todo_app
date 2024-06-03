import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/ui/themes.dart';
import 'package:todo_app/ui/widgets/inputfield.dart';

import '../../controllers/task_controller.dart';
import '../../models/task.dart';
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

  final Rxn<DateTime> _selectedDate = Rxn<DateTime>(DateTime.now());

  final RxString _startTime =
      DateFormat('hh:mm a').format(DateTime.now()).toString().obs;
  final RxString _endTime = DateFormat('hh:mm a')
      .format(DateTime.now().add(const Duration(minutes: 15)))
      .toString().obs;

  final _selectedRemind = 5.obs;
  List<int> remindList = [5, 10, 15, 20];
  final _selectedRepeat = 'None'.obs;
  List<String> repeatList = ['None', 'Daily', 'Weekly', 'Monthly'];
  final _selectedColor = 0.obs;
  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _customAppBar(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
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
                  validator:  (value) {
                    if (value == null || value.isEmpty) {
                      return null;
                    }
                    else if (!RegExp(r"^[a-zA-Z\s']+$").hasMatch(value!)) {
                      return 'Title should contain only text';
                    }
                    return null;
                    },
                ),
                InputField(
                  title: 'Note',
                  hint: 'Enter note here',
                  controller: _noteController,
                ),
                Obx(() => InputField(
                  title: 'Date',
                  hint:  _selectedDate.value != null ? DateFormat.yMd().format(_selectedDate.value!) : 'Select a date',
                  icon: IconButton(
                    onPressed: () { _getDateFromUser();},
                    icon: const Icon(Icons.calendar_today_outlined,
                        color: Colors.grey),
                  ),
                )
                ),
                Row(
                  children: [
                    Obx(() =>
                        Expanded(
                        child: InputField(
                          title: 'Start Time',
                          hint: _startTime.value,
                          icon: IconButton(
                            onPressed: (){
                                _getTimeFromUser(isStartTime: true);
                              },
                            icon: const Icon(Icons.access_time_rounded,
                                color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Obx(
                          () => Expanded(
                            child: InputField(
                              title: 'End Time',
                              hint: _endTime.value,
                              icon: IconButton(
                                onPressed: () {
                                    _getTimeFromUser(isStartTime: false);
                                  },
                                icon: const Icon(Icons.access_time_rounded,
                                    color: Colors.grey),
                            ),
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
                          if (_formKey.currentState!.validate()) {
                            _validateElements();
                            _taskController.getTasks();
                          }
                        },
                      ),
                    ]
                ),
              ],
            ),
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

  _validateElements()
  {
    if(_titleController.text.isNotEmpty && _noteController.text.isNotEmpty)
    {
      _addTasksToDB();
      Get.back();
    }
    else if(_titleController.text.isEmpty || _noteController.text.isEmpty)
    {
      Get.isDarkMode
          ?Get.snackbar(
            'Error',
            'All fields are required',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.white,
            colorText: pinkClr,
            icon: const Icon(Icons.warning_amber_outlined, color: Colors.black,),
          )
          :Get.snackbar(
            'Error',
            'All fields are required',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.black,
            colorText: pinkClr,
            icon: const Icon(Icons.warning_amber_outlined, color: Colors.white,),
          );
    }
    else {
      print('##### SOMETHING WENT WRONG #####');
    }
  }

  _addTasksToDB() async
  {
    try {
      int value = await _taskController.addTask(
          task: Task(
              title: _titleController.text,
              note: _noteController.text,
              startTime: _startTime.value,
              endTime: _endTime.value,
              date: DateFormat.yMd().format(_selectedDate.value!),
              isCompleted: 0,
              color: _selectedColor.value,
              remind: _selectedRemind.value,
              repeat: _selectedRepeat.value
          )
      );
      print('Task id is $value');
    }catch(e){
      print('error');
    }

  }

  _getDateFromUser() async
  {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate.value!,
        firstDate: DateTime(2015),
        lastDate: DateTime(2030),
        builder: ( context,  child)
        {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: Get.isDarkMode ? const ColorScheme.dark(
                // primary: Colors.white, // header background color
                brightness: Brightness.dark
              ) : const ColorScheme.light(
                primary: bluishClr, // header background color
                  brightness: Brightness.light
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: bluishClr, // button text color
                ),
              ),
            ),
            child: child!,
          );
        }
    );

    if(pickedDate !=  null){
      _selectedDate.value = pickedDate;
    }
    else {

    }
  }

  _getTimeFromUser({required bool isStartTime}) async
  {
    TimeOfDay? pickedTime = await showTimePicker(
      builder: (context, child) {
        return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: Get.isDarkMode ? const ColorScheme.dark(
                // primary: Colors.white, // header background color
                  brightness: Brightness.dark
              ) : const ColorScheme.light(
                  primary: bluishClr, // header background color
                  brightness: Brightness.light
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: bluishClr, // button text color
                ),
              ),
            ),
          child: child!,
        );
      },
      context: context,
      initialTime: isStartTime
          ?
          TimeOfDay.fromDateTime(DateTime.now())
          :TimeOfDay.fromDateTime(DateTime.now().add(const Duration(minutes: 15))),
    );
    // ignore: use_build_context_synchronously


    if(pickedTime !=  null && isStartTime){
      String formattedTime = pickedTime.format(context);
      _startTime.value = formattedTime;
    } else if(pickedTime !=  null && !isStartTime){
      String formattedTime = pickedTime.format(context);
      _endTime.value = formattedTime;
    } else {

    }
  }

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
