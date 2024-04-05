// // MachineSelectionScreen
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:spotbud/ui/view/log_workout/work_out_form.dart';
// import 'package:spotbud/ui/widgets/assets.dart';
// import 'package:spotbud/ui/widgets/button.dart';
// import 'package:spotbud/ui/widgets/color_theme.dart';
// import 'package:spotbud/ui/widgets/custom_loading_indicator.dart';
// import 'package:spotbud/ui/widgets/text.dart';
// import 'package:spotbud/ui/widgets/textform.dart';

// import '../../../viewmodels/user_data_viewmodel.dart';

// class MachineSelectionScreen extends StatelessWidget {
//   final String bodyPart;
//   final UserDataViewModel _userDataViewModel = Get.find();

//   MachineSelectionScreen({required this.bodyPart});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.bluebackgroundColor,
//       appBar: AppBar(
//         iconTheme: IconThemeData(color: AppColors.acccentColor),
//         backgroundColor: AppColors.bluebackgroundColor,
//         title: Text(
//           'Select Machine',
//           style: AppTheme.secondaryText(
//               fontWeight: FontWeight.w500, color: AppColors.acccentColor),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: FutureBuilder<List<String>>(
//           future: _userDataViewModel.getMachineNames(bodyPart),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Center(child: LoadingIndicator());
//             } else if (snapshot.hasError) {
//               return Center(child: Text('Error: ${snapshot.error}'));
//             } else {
//               List<String> machineNames = snapshot.data ?? [];
//               return Column(
//                 children: _buildButtonRows(machineNames),
//               );
//             }
//           },
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: AppColors.primaryColor,
//         shape: CircleBorder(),
//         onPressed: () => _showAddMachineDialog(),
//         child: Icon(
//           Icons.add,
//           color: AppColors.acccentColor,
//         ),
//       ),
//     );
//   }

//   void _showAddMachineDialog() {
//     TextEditingController machineController = TextEditingController();
//     Get.defaultDialog(
//       backgroundColor: AppColors.primaryColor,
//       title: 'Add New Machine',
//       titleStyle: TextStyle(
//         color: AppColors.acccentColor,
//         fontWeight: FontWeight.bold,
//         fontSize: 20,
//       ),
//       content: buildStyledInput(
//         controller: machineController,
//         hintText: "Enter the new Machine",
//         labelText: '',
//       ),
//       actions: <Widget>[
//         TextButton(
//           onPressed: () {
//             Get.back();
//           },
//           child: Text(
//             'Cancel',
//             style: TextStyle(
//               color: AppColors.backgroundColor,
//               fontSize: 16,
//             ),
//           ),
//         ),
//         ElevatedButton(
//           style: ButtonStyle(
//             backgroundColor: MaterialStateProperty.all(
//               AppColors.blue,
//             ),
//           ),
//           onPressed: () {
//             String machineName = machineController.text.trim();
//             if (machineName.isNotEmpty) {
//               _addNewMachine(machineName);
//               Get.back();
//               Get.back();
//             }
//           },
//           child: Text(
//             'Add',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 16,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   void _addNewMachine(String machineName) {
//     print('add custom machine called');
//     _userDataViewModel.addCustomMachine(bodyPart, machineName);
//   }

//   void _removeMachine(String machineName) {
//     _userDataViewModel.removeCustomMachine(bodyPart, machineName);
//     _userDataViewModel.update();
//   }

//   List<Widget> _buildButtonRows(List<String> machineNames) {
//     List<Widget> rows = [];
//     int numButtons = machineNames.length;
//     int numFullRows = numButtons ~/ 2; // Integer division

//     // Add rows with two buttons each
//     for (int i = 0; i < numFullRows; i++) {
//       rows.add(
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             _buildButton(machineNames[i * 2]),
//             _buildButton(machineNames[i * 2 + 1]),
//           ],
//         ),
//       );
//     }

//     // Add the last row if there's an odd number of buttons
//     if (numButtons % 2 != 0) {
//       rows.add(
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             _buildButton(machineNames[numButtons - 1]),
//           ],
//         ),
//       );
//     }

//     return rows;
//   }

//   Widget _buildButton(String machineName) {
//     return CustomMachineButton(
//       text: machineName,
//       onPressed: () {
//         _handleMachineSelection(machineName);
//       },
//       onRemovePressed: () {
//         _showRemoveMachineConfirmation(machineName);
//       },
//       imagePath: AppAssets.arms, // Set image path if needed
//     );
//   }

//   void _showRemoveMachineConfirmation(String machineName) {
//     Get.defaultDialog(
//       backgroundColor: AppColors.primaryColor,
//       title: 'Remove Machine',
//       titleStyle: TextStyle(
//         color: AppColors.acccentColor,
//         fontWeight: FontWeight.bold,
//         fontSize: 20,
//       ),
//       content: Container(
//         padding: EdgeInsets.symmetric(vertical: 20),
//         child: Column(
//           children: [
//             Text(
//               'Are you sure you want to remove $machineName?',
//               style: TextStyle(
//                 color: AppColors.acccentColor,
//                 fontSize: 16,
//               ),
//             ),
//             SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 TextButton(
//                   onPressed: () => Get.back(),
//                   child: Text(
//                     'Cancel',
//                     style: TextStyle(
//                       color: AppColors.acccentColor,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 20),
//                 ElevatedButton(
//                   onPressed: () {
//                     _removeMachine(machineName);
//                     Get.back();
//                     Get.back();
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.blue,
//                   ),
//                   child: Text(
//                     'Yes',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

// //   void _handleMachineSelection(String machine) {
// //     // Navigate to workout logging form and pass the selected machine
// //     Get.to(() => WorkoutLoggingForm(bodyPart: bodyPart, machine: machine));
// //   }
// // }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/ui/view/log_workout/work_out_form.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';
import 'package:spotbud/ui/widgets/text.dart';

class MachineSelectionScreen extends StatelessWidget {
  final MachineSelectionController _controller =
      Get.put(MachineSelectionController());

  @override
  Widget build(BuildContext context) {
    final String bodyPart = Get.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Machine'),
      ),
      body: Obx(() => ListView.builder(
            itemCount: _controller.machines.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_controller.machines[index]),
                onTap: () {
                  _controller.selectMachine(index);
                  Get.back(result: _controller.machines[index]);
                },
              );
            },
          )),
    );
  }
}
