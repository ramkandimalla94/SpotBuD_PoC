import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/ui/view/log_workout/machine_selection_view.dart';
import 'package:spotbud/ui/widgets/assets.dart';
import 'package:spotbud/ui/widgets/button.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';
import 'package:spotbud/ui/widgets/custom_loading_indicator.dart';
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
            fontWeight: FontWeight.w500,
            color: AppColors.acccentColor,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _userDataViewModel.fetchBodyParts();
        },
        child: GetBuilder<UserDataViewModel>(
          builder: (userDataController) {
            if (userDataController.isLoading.value) {
              return Center(child: LoadingIndicator());
            } else if (userDataController.error.value.isNotEmpty) {
              return Center(
                  child: Text('Error: ${userDataController.error.value}'));
            } else {
              List<String> bodyParts = userDataController.bodyParts;
              return SingleChildScrollView(
                child: Column(
                  children: _buildButtonRows(bodyParts),
                ),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddBodyPartDialog(),
        child: Icon(Icons.add),
      ),
    );
  }

  List<Widget> _buildButtonRows(List<String> bodyParts) {
    List<Widget> rows = [];
    int numButtons = bodyParts.length;
    int numFullRows = numButtons ~/ 2; // Integer division

    // Add rows with two buttons each
    for (int i = 0; i < numFullRows; i++) {
      rows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildButton(bodyParts[i * 2]),
            _buildButton(bodyParts[i * 2 + 1]),
          ],
        ),
      );
    }

    // Add the last row if there's an odd number of buttons
    if (numButtons % 2 != 0) {
      rows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildButton(bodyParts[numButtons - 1]),
          ],
        ),
      );
    }

    return rows;
  }

  Widget _buildButton(String bodyPart) {
    String imagePath = _getAppropriateImagePath(bodyPart);
    return custombodybutton(
      text: bodyPart,
      onPressed: () {
        _handleBodyPartSelection(bodyPart);
      },
      imagePath: imagePath,
    );
  }

  String _getAppropriateImagePath(String bodyPart) {
    // Add logic to determine image path based on body part
    // For now, returning a default image
    return AppAssets.legs;
  }

  void _showAddBodyPartDialog() {
    TextEditingController _bodyPartController = TextEditingController();

    Get.defaultDialog(
      title: 'Add Body Part',
      content: TextField(
        controller: _bodyPartController,
        decoration: InputDecoration(labelText: 'Enter Body Part'),
      ),
      textConfirm: 'Add',
      confirmTextColor: Colors.white,
      onConfirm: () {
        _addCustomBodyPart(_bodyPartController.text);
        Get.back(); // Close the dialog
      },
    );
  }

  void _addCustomBodyPart(String bodyPart) async {
    await _userDataViewModel.addCustomBodyPart(bodyPart);
    // No need to fetch body parts again, as the RefreshIndicator will trigger a refresh
  }

  void _handleBodyPartSelection(String bodyPart) {
    // Navigate to machine selection screen and pass the selected body part
    Get.to(() => MachineSelectionScreen(bodyPart: bodyPart));
  }
}
