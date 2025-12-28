import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controller/App_Controller.dart';

class Homepage extends StatelessWidget {
  Homepage({super.key});

  final controller = Get.put(AppController());
  final nameController = TextEditingController();
  final numberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xDFFFFFFF),

      //📘 Notebook-style AppBar
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: const Color(0xFF1E2A78), // Navy blue cover
        title: const Text(
          "📘 My Node Book",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
            letterSpacing: 1,
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
      ),

      // ➕ FAB
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF03A9F4),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Add", style: TextStyle(color: Colors.white)),
        onPressed: () => _showDialog(context),
      ),

      // 📃 Contact List
      body: Obx(() {
        if (controller.dataList.isEmpty) {
          return const Center(
            child: Text(
              "No contacts yet 🗒️",
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(top: 16, bottom: 80),
          itemCount: controller.dataList.length,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            final item = controller.dataList[index];

            return TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: Duration(milliseconds: 400 + index * 50),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - value)),
                    child: child,
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  leading: CircleAvatar(
                    radius: 22,
                    backgroundColor: const Color(0xFFE3F2FD),
                    child: const Icon(Icons.person, color: Color(0xFF1E2A78)),
                  ),
                  title: Text(
                    item["name"] ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      item["number"] ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Color(0xFF03A9F4)),
                        onPressed: () => _showDialog(context, index: index),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () =>
                            controller.deleteDataWithUndo(index, context),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  // ➕➕ Dialog (Add / Update)
  void _showDialog(BuildContext context, {int? index}) {
    if (index != null) {
      nameController.text = controller.dataList[index]["name"]!;
      numberController.text = controller.dataList[index]["number"]!;
    } else {
      nameController.clear();
      numberController.clear();
    }

    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: const Color(0xFFFFFDF5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                index == null ? "Add Contact" : "Update Contact",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E2A78),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Name",
                  filled: true,
                  fillColor: const Color(0xFFF2F1EF),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: numberController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: "Phone Number",
                  filled: true,
                  fillColor: const Color(0xFFF2F1EF),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 26),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF03A9F4),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      if (index == null) {
                        controller.addData(
                          nameController.text,
                          numberController.text,
                        );
                      } else {
                        controller.updateData(
                          index,
                          nameController.text,
                          numberController.text,
                        );
                      }
                      Get.back();
                    },
                    child: Text(index == null ? "Save" : "Update"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

///=========================================================
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../Controller/App_Controller.dart';
//
// class Homepage extends StatelessWidget {
//   Homepage({super.key});
//
//   final controller = Get.put(AppController());
//   final nameController = TextEditingController();
//   final numberController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xDFFFFFFF), // 📜 Paper background
//
//       // 📘 Notebook-style AppBar
//       appBar: AppBar(
//         elevation: 0,
//         centerTitle: true,
//         backgroundColor: const Color(0xFF1E2A78), // Navy blue cover
//         title: const Text(
//           "📘 My Node Book",
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 20,
//             color: Colors.white,
//             letterSpacing: 1,
//           ),
//         ),
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
//         ),
//       ),
//
//       // ➕ FAB with sky blue
//       floatingActionButton: FloatingActionButton.extended(
//         backgroundColor: const Color(0xFF03A9F4), // Sky blue
//         icon: const Icon(Icons.add, color: Colors.white),
//         label: const Text("Add", style: TextStyle(color: Colors.white)),
//         onPressed: () => _showAddDialog(context),
//       ),
//
//       // 📃 Contact List
//       body: Obx(() {
//         if (controller.dataList.isEmpty) {
//           return const Center(
//             child: Text(
//               "No contacts yet 🗒️",
//               style: TextStyle(fontSize: 18, color: Colors.black54),
//             ),
//           );
//         }
//
//         return ListView.builder(
//           padding: const EdgeInsets.only(top: 16, bottom: 80),
//           physics: const BouncingScrollPhysics(),
//           itemCount: controller.dataList.length,
//           itemBuilder: (context, index) {
//             final item = controller.dataList[index];
//
//             return TweenAnimationBuilder(
//               tween: Tween<double>(begin: 0, end: 1),
//               duration: Duration(milliseconds: 400 + index * 70),
//               builder: (context, value, child) {
//                 return Opacity(
//                   opacity: value,
//                   child: Transform.translate(
//                     offset: Offset(0, 20 * (1 - value)),
//                     child: child,
//                   ),
//                 );
//               },
//               child: Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(14),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.05),
//                       blurRadius: 8,
//                       offset: const Offset(0, 4),
//                     )
//                   ],
//                 ),
//                 child: ListTile(
//                   contentPadding:
//                   const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
//                   leading: CircleAvatar(
//                     radius: 22,
//                     backgroundColor: const Color(0xFFE3F2FD), // Soft blue
//                     child:
//                     const Icon(Icons.person, color: Color(0xFF1E2A78)),
//                   ),
//                   title: Text(
//                     item["name"] ?? '',
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   subtitle: Text(
//                     item["number"] ?? '',
//                     style: const TextStyle(
//                       fontSize: 14,
//                       color: Colors.black54,
//                     ),
//                   ),
//                   trailing: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       IconButton(
//                         icon:
//                         const Icon(Icons.edit, color: Color(0xFF1E88E5)),
//                         onPressed: () => _showUpdateDialog(context, index),
//                       ),
//                       IconButton(
//                         icon:
//                         const Icon(Icons.delete, color: Colors.redAccent),
//                         onPressed: () => controller.deleteData(index),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       }),
//     );
//   }
//
//   // ➕ Add Dialog
//   void _showAddDialog(BuildContext context) {
//     nameController.clear();
//     numberController.clear();
//
//     _showDialogTemplate(
//       context,
//       title: "Add Contact",
//       buttonText: "Save",
//       icon: Icons.save,
//       onPressed: () {
//         if (nameController.text.isNotEmpty &&
//             numberController.text.isNotEmpty) {
//           controller.addData(
//             nameController.text.trim(),
//             numberController.text.trim(),
//           );
//           Get.back();
//         }
//       },
//     );
//   }
//
//   // ✏️ Update Dialog
//   void _showUpdateDialog(BuildContext context, int index) {
//     final item = controller.dataList[index];
//     nameController.text = item["name"]!;
//     numberController.text = item["number"]!;
//
//     _showDialogTemplate(
//       context,
//       title: "Update Contact",
//       buttonText: "Update",
//       icon: Icons.update,
//       onPressed: () {
//         controller.updateData(
//           index,
//           nameController.text.trim(),
//           numberController.text.trim(),
//         );
//         Get.back();
//       },
//     );
//   }
//
//   // 📦 Reusable Dialog
//   void _showDialogTemplate(
//       BuildContext context, {
//         required String title,
//         required String buttonText,
//         required IconData icon,
//         required VoidCallback onPressed,
//       }) {
//     showDialog(
//       context: context,
//       builder: (_) => Dialog(
//         backgroundColor: const Color(0xFFFFFDF5),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         child: Padding(
//           padding: const EdgeInsets.all(22),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 title,
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF1E2A78),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               TextField(
//                 controller: nameController,
//                 decoration: InputDecoration(
//                   labelText: "Name",
//                   filled: true,
//                   fillColor: const Color(0xFFF2F1EF),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(14),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 12),
//               TextField(
//                 controller: numberController,
//                 keyboardType: TextInputType.phone,
//                 decoration: InputDecoration(
//                   labelText: "Phone Number",
//                   filled: true,
//                   fillColor: const Color(0xFFF2F1EF),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(14),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 26),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   TextButton(
//                     onPressed: () => Get.back(),
//                     child: const Text("Cancel"),
//                   ),
//                   ElevatedButton.icon(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF03A9F4),
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 18, vertical: 12),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(14),
//                       ),
//                     ),
//                     icon: Icon(icon),
//                     label: Text(buttonText),
//                     onPressed: onPressed,
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
