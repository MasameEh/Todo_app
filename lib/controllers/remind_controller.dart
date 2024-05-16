import 'package:get/get.dart';

class RemindController extends GetxController {
  var selectedRemind = RxInt(0);

  void setSelectedRemind(int remindValue) {
    selectedRemind.value = remindValue;
  }
}