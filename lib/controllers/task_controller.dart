import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';

class TaskController extends GetxController {

    final List<Task> taskList = [
        Task(
            id: 1,
            title: 'Task 1',
            color: 0,
            isCompleted: 0,
            note: 'Note Something',
            startTime: DateFormat('hh:mm a')
                .format(DateTime.now().add(const Duration(minutes: 1)))
                .toString(),
            ),
    ];

    getTasks()
    {

    }
}
