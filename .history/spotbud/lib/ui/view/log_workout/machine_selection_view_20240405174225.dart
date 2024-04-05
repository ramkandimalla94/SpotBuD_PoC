import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';
import 'package:spotbud/ui/widgets/custom_loading_indicator.dart';
import 'package:spotbud/ui/widgets/text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.acccentColor,
        onPressed: () {
          _showAddExerciseDialog();
        },
        child: Icon(Icons.add),
      ),
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

  final exerciseTypes = [
    'Strength: Weight Reps',
    'Strength: Weight Time',
    'Body Weight: Reps',
    'Body Weight: Time',
    'Cardio: Time, Distance, kcal',
    'Others'
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

  void addExercise() {
    final exerciseName = exerciseNameController.text;
    if (exerciseName.isNotEmpty &&
        selectedBodyPart.isNotEmpty &&
        selectedExerciseType.isNotEmpty) {
      // Save the exercise to Firebase or perform any other necessary action
      print('Exercise Name: $exerciseName');
      print('Body Part: $selectedBodyPart');
      print('Exercise Type: $selectedExerciseType');
      print('Single Leg/Single Arm: $singleLegOrArm');
      // Clear input fields after saving
      exerciseNameController.clear();
      selectedBodyPart.value = '';
      selectedExerciseType.value = '';
      singleLegOrArm.value = false;
    } else {
      Get.snackbar(
        'Error',
        'Please fill in all fields before saving the exercise.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    // Clean up controllers when the controller is closed
    exerciseNameController.dispose();
    super.onClose();
  }
}
