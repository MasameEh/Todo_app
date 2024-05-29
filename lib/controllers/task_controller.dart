import 'package:get/get.dart';
import 'package:todo_app/db/db_helper.dart';
import '../models/task.dart';

class TaskController extends GetxController {

    final RxList<Task> taskList = <Task>[].obs;


    @override
    void onInit() {
        getTasks();
        super.onInit();
    }

    Future<int> addTask({Task? task}) async
    {
        return DBHelper.insert(task);
    }

    Future<void> getTasks() async
    {
        final List<Map<String, dynamic>> tasks = await DBHelper.query();
        taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
        print(taskList);
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
