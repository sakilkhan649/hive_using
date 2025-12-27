import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AppController extends GetxController {
  var dataList = <Map<String, String>>[].obs;
  late Box box;

  @override
  void onInit() {
    super.onInit();
    box = Hive.box('DB');
    loadData();
  }

  void loadData() {
    List users = box.get("users", defaultValue: []);
    // ✅ FIX: Safe conversion from dynamic Map to Map<String, String>
    dataList.value = users.map<Map<String, String>>((item) {
      return Map<String, String>.from(item);
    }).toList();
  }

  void addData(String name, String number) {
    List users = box.get("users", defaultValue: []);
    users.add({
      "name": name,
      "number": number,
    });
    box.put("users", users);
    loadData();
  }

  void deleteData(int index) {
    List users = box.get("users", defaultValue: []);
    users.removeAt(index);
    box.put("users", users);
    loadData();
  }

  void updateData(int index, String name, String number) {
    List users = box.get("users", defaultValue: []);
    users[index] = {
      "name": name,
      "number": number,
    };
    box.put("users", users);
    loadData();
  }
}
