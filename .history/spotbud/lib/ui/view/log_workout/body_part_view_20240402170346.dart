import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/ui/view/log_workout/machine_selection_view.dart';
import 'package:spotbud/ui/widgets/assets.dart';
import 'package:spotbud/ui/widgets/button.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';
import 'package:spotbud/ui/widgets/custom_loading_indicator.dart';
import 'package:spotbud/ui/widgets/text.dart';
import 'package:spotbud/ui/widgets/textform.dart';
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
      body: SingleChildScrollView(
        child: FutureBuilder<List<String>>(
          future: _userDataViewModel.getBodyParts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: LoadingIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              List<String> bodyParts = snapshot.data ?? [];
              return _buildBodyPartButtons(bodyParts);
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.acccentColor,
        shape: CircleBorder(),
        onPressed: () {
          _showAddBodyPartDialog();
        },
        child: Icon(
          Icons.add,
          color: AppColors.primaryColor,
        ),
      ),
    );
  }

  Widget _buildBodyPartButtons(List<String> bodyParts) {
    List<Widget> rows = [];
    for (int i = 0; i < bodyParts.length; i += 2) {
      if (i + 1 < bodyParts.length) {
        // If there are at least two more elements
        rows.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildButton(bodyParts[i]),
              _buildButton(bodyParts[i + 1]),
            ],
          ),
        );
      } else {
        // If there's only one more element
        rows.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildButton(bodyParts[i]),
            ],
          ),
        );
      }
    }
    return Column(
      children: rows,
    );
  }

  Widget _buildButton(String bodyPart) {
    String imagePath = _getAppropriateImagePath(bodyPart);
    return custombodybutton(
      text: bodyPart,
      onPressed: () {
        _handleBodyPartSelection(bodyPart);
      },
      imagePath: imagePath,
      onRemovePressed: () {
        _showRemoveBodyPartConfirmation(bodyPart);
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

  void _showAddBodyPartDialog() {
    TextEditingController _bodyPartController = TextEditingController();
    Get.defaultDialog(
      backgroundColor: AppColors.primaryColor,
      title: 'Add Body Part',
      titleStyle: TextStyle(
        color: AppColors.acccentColor,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
      content: buildStyledInput(
        controller: _bodyPartController,
        hintText: "Enter the body part name",
        labelText: '',
      ),

      // TextField(
      //   controller: _bodyPartController,
      //   decoration: InputDecoration(hintText: 'Enter Body Part'),
      // ),
      actions: <Widget>[
        TextButton(
          child: Text(
            'Cancel',
            style: TextStyle(
              color: AppColors.backgroundColor,
              fontSize: 16,
            ),
          ),
          onPressed: () {
            Get.back();
          },
        ),
        TextButton(
          child: Text(
            'Add',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          onPressed: () {
            String bodyPart = _bodyPartController.text.trim();
            if (bodyPart.isNotEmpty) {
              _addCustomBodyPart(bodyPart);
              Get.back();
            }
          },
        ),
      ],
    );
  }

  void _addCustomBodyPart(String bodyPart) {
    _userDataViewModel.addCustomBodyPart(bodyPart);
    _userDataViewModel.update();
  }

  void _showRemoveBodyPartConfirmation(String bodyPart) {
    Get.defaultDialog(
      backgroundColor: AppColors.primaryColor,
      title: 'Remove Body Part',
      titleStyle: TextStyle(
        color: AppColors.acccentColor,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
      content: Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Text(
              'Are you sure you want to remove $bodyPart?',
              style: TextStyle(
                color: AppColors.acccentColor,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: AppColors.acccentColor,
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    _removeBodyPart(bodyPart);
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blue,
                  ),
                  child: Text(
                    'Yes',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _removeBodyPart(String bodyPart) {
    _userDataViewModel.removeBodyPart(bodyPart);
    _userDataViewModel.update();
  }
}
