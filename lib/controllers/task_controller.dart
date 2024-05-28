import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/db/db_helper.dart';
import '../models/task.dart';

class TaskController extends GetxController {

    final taskList = [].obs;


    Future<int> addTask({Task? task}) async
    {
        return await DBHelper.insert(task);
    }

    Future<void> getTasks() async
    {
        final List<Map<String, dynamic>> tasks = await DBHelper.query();
        taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
    }

    void deleteTasks(Task task) async
    {
        await DBHelper.delete(task);
        getTasks();
    }

    void markTaskAsCompleted(int id) async
    {
        await DBHelper.update(id);
        getTasks();
    }
}
