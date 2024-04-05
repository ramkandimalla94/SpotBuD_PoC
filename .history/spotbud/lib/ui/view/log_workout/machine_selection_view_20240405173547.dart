import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';
import 'package:spotbud/ui/widgets/custom_loading_indicator.dart';
import 'package:spotbud/ui/widgets/text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MachineSelectionScreen extends StatefulWidget {
  @override
  _MachineSelectionScreenState createState() => _MachineSelectionScreenState();
}

class _MachineSelectionScreenState extends State<MachineSelectionScreen> {
  final MachineSelectionController controller =
      Get.put(MachineSelectionController());

  bool _singleLegOrArm = false; // New variable to manage checkbox state

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
        onPressed: () => _showAddExerciseDialog(context),
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

  void _showAddExerciseDialog(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    String? selectedBodyPart;
    String? selectedExerciseType;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Exercise'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                SizedBox(height: 8.0),
                DropdownButtonFormField<String>(
                  value: selectedBodyPart,
                  decoration: InputDecoration(labelText: 'Body Part'),
                  onChanged: (value) {
                    selectedBodyPart = value;
                  },
                  items: controller.bodyParts
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(height: 8.0),
                DropdownButtonFormField<String>(
                  value: selectedExerciseType,
                  decoration: InputDecoration(labelText: 'Exercise Type'),
                  onChanged: (value) {
                    selectedExerciseType = value;
                  },
                  items: [
                    'Strength: Weight Reps',
                    'Strength: Weight Time',
                    'Body Weight: Reps',
                    'Body Weight: Time',
                    'Cardio: Time, Distance, Kcal',
                    'Others'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(height: 8.0),
                Row(
                  children: [
                    Text('Single Leg/Single Arm'),
                    SizedBox(width: 8.0),
                    Checkbox(
                      value: _singleLegOrArm, // Use _singleLegOrArm for value
                      onChanged: (value) {
                        setState(() {
                          _singleLegOrArm = value ?? false; // Update state
                        });
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
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty &&
                    selectedBodyPart != null &&
                    selectedExerciseType != null) {
                  await controller.addCustomExercise(
                    nameController.text,
                    selectedBodyPart!,
                    selectedExerciseType!,
                    _singleLegOrArm, // Pass _singleLegOrArm to the function
                  );
                  Navigator.of(context).pop();
                }
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

  Future<void> addCustomExercise(
    String name,
    String bodyPart,
    String exerciseType,
    bool singleLegOrArm,
  ) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        await FirebaseFirestore.instance
            .collection('data')
            .doc(currentUser.uid)
            .update({
          'customExercise': FieldValue.arrayUnion([
            {
              'name': name,
              'bodyPart': bodyPart,
              'exerciseType': exerciseType,
              'singleLegOrArm': singleLegOrArm,
            }
          ]),
        });
        // Reload data
        _loadData();
      }
    } catch (e) {
      print('Error adding custom exercise: $e');
    }
  }
}
