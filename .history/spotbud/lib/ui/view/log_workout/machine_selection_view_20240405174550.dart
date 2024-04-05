import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';
import 'package:spotbud/ui/widgets/custom_loading_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spotbud/ui/widgets/text.dart';

class MachineSelectionScreen extends StatelessWidget {
  final MachineSelectionController controller =
      Get.put(MachineSelectionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        iconTheme: IconThemeData(color: AppColors.acccentColor),
        title: Text(
          'Select Exercise',
          style: AppTheme.secondaryText(
              fontWeight: FontWeight.w500, color: AppColors.acccentColor),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddExerciseDialog(context);
        },
        backgroundColor: AppColors.acccentColor,
        child: Icon(Icons.add),
      ),
      body: Obx(() {
        if (controller.loading.value) {
          return Center(
            child: LoadingIndicator(),
          );
        } else {
          return ListView.builder(
            itemCount: controller.bodyParts.length,
            itemBuilder: (context, index) {
              final bodyPart = controller.bodyParts[index];
              final machines = controller.machinesByBodyPart[bodyPart] ?? [];
              return ExpansionTile(
                trailing: Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.acccentColor,
                ),
                title: Text(
                  bodyPart,
                  style: AppTheme.secondaryText(
                      size: 22,
                      fontWeight: FontWeight.w500,
                      color: AppColors.acccentColor),
                ),
                children: machines
                    .map((machine) => ListTile(
                          title: Text(
                            machine,
                            style: AppTheme.secondaryText(
                                size: 20,
                                fontWeight: FontWeight.w500,
                                color: AppColors.secondaryColor),
                          ),
                          onTap: () {
                            Get.back(result: {
                              'bodyPart': bodyPart,
                              'machine': machine
                            });
                          },
                        ))
                    .toList(),
              );
            },
          );
        }
      }),
    );
  }

  Future<void> _showAddExerciseDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Exercise'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: controller.exerciseNameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                SizedBox(height: 10),
                DropdownButtonFormField(
                  value: controller.selectedBodyPart.value,
                  onChanged: (newValue) {
                    controller.selectedBodyPart.value = newValue.toString();
                  },
                  items: controller.bodyParts.map((String bodyPart) {
                    return DropdownMenuItem(
                      value: bodyPart,
                      child: Text(bodyPart),
                    );
                  }).toList(),
                  decoration: InputDecoration(labelText: 'Body Part'),
                ),
                SizedBox(height: 10),
                DropdownButtonFormField(
                  value: controller.selectedExerciseType.value,
                  onChanged: (newValue) {
                    controller.selectedExerciseType.value = newValue.toString();
                  },
                  items: controller.exerciseTypes.map((String type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  decoration: InputDecoration(labelText: 'Exercise Type'),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text('Single Leg/Single Arm'),
                    SizedBox(width: 10),
                    Checkbox(
                      value: controller.singleLegOrArm.value,
                      onChanged: (value) {
                        controller.singleLegOrArm.value = value ?? false;
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                controller.addCustomExercise();
                Get.back();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}

class MachineSelectionController extends GetxController {
  var bodyParts = <String>[].obs;
  var machinesByBodyPart = <String, List<String>>{}.obs;
  var loading = false.obs;
  var exerciseNameController = TextEditingController();
  var selectedBodyPart = ''.obs;
  var selectedExerciseType = ''.obs;
  var singleLegOrArm = false.obs;

  List<String> get exerciseTypes => [
        'Strength: Weight Reps',
        'Strength: Weight Time',
        'Body Weight: Reps',
        'Body Weight: Time',
        'Cardio: Time, Distance, Kcal',
        'Others',
      ];

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  void _loadData() async {
    try {
      loading.value = true; // Start loading
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final docSnapshot = await FirebaseFirestore.instance
            .collection('data')
            .doc(currentUser.uid)
            .get();
        if (docSnapshot.exists) {
          final userData = docSnapshot.data();
          if (userData != null) {
            final customMachines = userData['customMachine'] as List<dynamic>;

            // Clear previous data
            bodyParts.clear();
            machinesByBodyPart.clear();

            // Process fetched data
            customMachines.forEach((customMachine) {
              final bodyPart = customMachine['bodypart'] as String;
              final machines = (customMachine['machine'] as List<dynamic>)
                  .map((machine) => machine['name'] as String)
                  .toList();

              if (!bodyParts.contains(bodyPart)) {
                bodyParts.add(bodyPart);
              }

              if (!machinesByBodyPart.containsKey(bodyPart)) {
                machinesByBodyPart[bodyPart] = [];
              }

              machinesByBodyPart[bodyPart]?.addAll(machines);
            });

            // Sort machines alphabetically
            machinesByBodyPart.forEach((key, value) {
              machinesByBodyPart[key]?.sort();
            });
          }
        }
      }

      loading.value = false; // Data loading complete
    } catch (e) {
      print('Error loading data: $e');
      loading.value = false; // Error occurred, stop loading
    }
  }

  void addCustomExercise() {
    final exerciseName = exerciseNameController.text;
    final bodyPart = selectedBodyPart.value;
    final exerciseType = selectedExerciseType.value;
    final isSingleLegOrArm = singleLegOrArm.value;

    if (exerciseName.isNotEmpty &&
        bodyPart.isNotEmpty &&
        exerciseType.isNotEmpty) {
      // Save the custom exercise to Firestore or perform any other action
      print('Custom Exercise Details:');
      print('Name: $exerciseName');
      print('Body Part: $bodyPart');
      print('Exercise Type: $exerciseType');
      print('Single Leg/Arm: $isSingleLegOrArm');
    } else {
      // Handle empty fields
      print('Please fill all fields');
    }
  }
}
