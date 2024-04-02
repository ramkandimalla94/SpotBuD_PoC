import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/ui/view/log_workout/machine_selection_view.dart';
import 'package:spotbud/ui/widgets/assets.dart';
import 'package:spotbud/ui/widgets/button.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';
import 'package:spotbud/ui/widgets/text.dart';
import 'package:spotbud/viewmodels/user_data_viewmodel.dart';

class BodyPartSelectionScreen extends StatelessWidget {
  final UserDataViewModel _userDataViewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bluebackgroundColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.acccentColor),
        backgroundColor: AppColors.bluebackgroundColor,
        title: Text(
          'Select Body Part',
          style: AppTheme.secondaryText(
              fontWeight: FontWeight.w500, color: AppColors.acccentColor),
        ),
      ),
      body: FutureBuilder(
        future: _userDataViewModel.getBodyParts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<String> bodyParts = snapshot.data as List<String>;
            return Column(
              children: [
                Expanded(
                  child: _buildBodyPartButtons(bodyParts),
                ),
              ],
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addNewBodyPart();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildBodyPartButtons(List<String> bodyParts) {
    return ListView.builder(
      itemCount: bodyParts.length,
      itemBuilder: (context, index) {
        String bodyPart = bodyParts[index];
        String imagePath = _getAppropriateImagePath(bodyPart);
        return custombodybutton(
          text: bodyPart,
          onPressed: () {
            _handleBodyPartSelection(bodyPart);
          },
          imagePath: imagePath,
        );
      },
    );
  }

  String _getAppropriateImagePath(String bodyPart) {
    // Add logic to determine image path based on body part
    // For now, returning a default image
    return AppAssets.legs;
  }

  void _handleBodyPartSelection(String bodyPart) {
    // Navigate to machine selection screen and pass the selected body part
    Get.to(() => MachineSelectionScreen(bodyPart: bodyPart));
  }

  void _addNewBodyPart() {
    Get.defaultDialog(
      title: 'Add New Body Part',
      content: TextField(
        controller: TextEditingController(),
        decoration: InputDecoration(labelText: 'Body Part'),
      ),
      textConfirm: 'Add',
      onConfirm: () {
        String newBodyPart = Get.arguments;
        if (newBodyPart.isNotEmpty) {
          _userDataViewModel.addCustomBodyPart(newBodyPart);
          Get.back();
        }
      },
      onCancel: () {
        Get.back();
      },
    );
  }
}
