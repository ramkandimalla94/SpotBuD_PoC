import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';
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
      body: ListView.builder(
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
                      trailing: Icon(
                        Icons.arrow_drop_down,
                        color: AppColors.acccentColor,
                      ),
                      title: Text(
                        machine,
                        style: AppTheme.secondaryText(
                            size: 15,
                            fontWeight: FontWeight.w500,
                            color: AppColors.acccentColor),
                      ),
                      onTap: () {
                        Get.back(
                            result: {'bodyPart': bodyPart, 'machine': machine});
                      },
                    ))
                .toList(),
          );
        },
      ),
    );
  }
}

class MachineSelectionController extends GetxController {
  var bodyParts = <String>[].obs;
  var machinesByBodyPart = <String, List<String>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  void _loadData() {
    // Simulated data loading
    // You would replace this with actual data fetching logic, e.g., from a database
    bodyParts.value = ['Chest', 'Back', 'Legs', 'Arms'];

    machinesByBodyPart.value = {
      'Chest': ['Bench Press', 'Incline Press', 'Fly'],
      'Back': ['Pull-up', 'Deadlift', 'Row'],
      'Legs': ['Squat', 'Leg Press', 'Deadlift'],
      'Arms': ['Bicep Curl', 'Tricep Extension', 'Hammer Curl'],
    };
  }
}
