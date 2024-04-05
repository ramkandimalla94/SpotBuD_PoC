import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';
import 'package:spotbud/ui/widgets/text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
            child: CircularProgressIndicator(),
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
      // Fetch data from Firestore
      final querySnapshot =
          await FirebaseFirestore.instance.collection('data').get();

      // Clear previous data
      bodyParts.clear();
      machinesByBodyPart.clear();

      // Process fetched data
      querySnapshot.docs.forEach((doc) {
        final data = doc.data();
        final customMachines = data['customMachine'] as List<dynamic>;

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
      });

      // Sort machines alphabetically
      machinesByBodyPart.forEach((key, value) {
        machinesByBodyPart[key]?.sort();
      });

      loading.value = false; // Data loading complete
    } catch (e) {
      print('Error loading data: $e');
      loading.value = false; // Error occurred, stop loading
    }
  }
}
