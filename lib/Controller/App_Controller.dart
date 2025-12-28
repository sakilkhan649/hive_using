import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AppController extends GetxController {
  var dataList = <Map<String, String>>[].obs;
  late Box box;

  static const _userKey = "users";
  static const _snackDuration = Duration(seconds: 3);

  @override
  void onInit() {
    super.onInit();
    box = Hive.box('DB');
    loadData();
  }

  // 📥 Load data
  void loadData() {
    List users = box.get(_userKey, defaultValue: []);
    dataList.value = users.map<Map<String, String>>((item) {
      return Map<String, String>.from(item);
    }).toList();
  }

  // ➕ Add
  void addData(String name, String number) {
    List users = box.get(_userKey, defaultValue: []);
    users.add({"name": name, "number": number});
    box.put(_userKey, users);
    loadData();
  }

  // ✏️ Update
  void updateData(int index, String name, String number) {
    List users = box.get(_userKey, defaultValue: []);
    users[index] = {"name": name, "number": number};
    box.put(_userKey, users);
    loadData();
  }

  // 🗑️ Delete with UNDO
  void deleteDataWithUndo(int index, BuildContext context) {
    List users = box.get(_userKey, defaultValue: []);
    final deletedItem = users[index];

    users.removeAt(index);
    box.put(_userKey, users);
    loadData();

    _showTopUndoSnackbar(context, index, deletedItem);
  }

  // 🔔 Top Snackbar (Safe)
  void _showTopUndoSnackbar(
      BuildContext context, int index, Map deletedItem) {
    final overlay = Overlay.of(context);
    if (overlay == null) return;

    late OverlayEntry overlayEntry;
    bool isRemoved = false;

    overlayEntry = OverlayEntry(
      builder: (_) => Positioned(
        top: 40,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E2A78), Color(0xFF03A9F4)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                )
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.delete_forever, color: Colors.white),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    "Contact deleted",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (isRemoved) return;
                    List users = box.get(_userKey, defaultValue: []);
                    users.insert(
                        index, Map<String, String>.from(deletedItem));
                    box.put(_userKey, users);
                    loadData();
                    try {
                      overlayEntry.remove();
                    } catch (_) {}
                    isRemoved = true;
                  },
                  child: const Text(
                    "UNDO",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    // ⏳ Auto dismiss
    Future.delayed(_snackDuration, () {
      if (!isRemoved) {
        try {
          overlayEntry.remove();
        } catch (_) {}
        isRemoved = true;
      }
    });
  }
}
///==========================================
// import 'package:get/get.dart';
// import 'package:hive_flutter/hive_flutter.dart';
//
// class AppController extends GetxController {
//   var dataList = <Map<String, String>>[].obs;
//   late Box box;
//
//   @override
//   void onInit() {
//     super.onInit();
//     box = Hive.box('DB');
//     loadData();
//   }
//
//   void loadData() {
//     List users = box.get("users", defaultValue: []);
//     // ✅ FIX: Safe conversion from dynamic Map to Map<String, String>
//     dataList.value = users.map<Map<String, String>>((item) {
//       return Map<String, String>.from(item);
//     }).toList();
//   }
//
//   void addData(String name, String number) {
//     List users = box.get("users", defaultValue: []);
//     users.add({
//       "name": name,
//       "number": number,
//     });
//     box.put("users", users);
//     loadData();
//   }
//
//   void deleteData(int index) {
//     List users = box.get("users", defaultValue: []);
//     users.removeAt(index);
//     box.put("users", users);
//     loadData();
//   }
//
//   void updateData(int index, String name, String number) {
//     List users = box.get("users", defaultValue: []);
//     users[index] = {
//       "name": name,
//       "number": number,
//     };
//     box.put("users", users);
//     loadData();
//   }
// }