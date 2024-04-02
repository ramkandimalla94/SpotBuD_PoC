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
  void initState() {
    super.initState();
    _userDataViewModel.getBodyParts(); // Call the function here
  }

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
      body: RefreshIndicator(
        onRefresh: () async {
          // Fetch data again from the database
          _userDataViewModel.getBodyParts();
        },
        child: SingleChildScrollView(
          child: Obx(() {
            if (_userDataViewModel.isLoading.value) {
              return Center(child: LoadingIndicator());
            } else {
              List<String> bodyParts = _userDataViewModel.bodyParts;
              return _buildBodyPartButtons(bodyParts);
            }
          }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddBodyPartDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildBodyPartButtons(List<String> bodyParts) {
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

    return Column(
      children: rows,
    );
  }

  Widget _buildButton(String bodyPart) {
    String imagePath = _getAppropriateImagePath(bodyPart);
    return Stack(
      children: [
        custombodybutton(
          text: bodyPart,
          onPressed: () {
            _handleBodyPartSelection(bodyPart);
          },
          imagePath: imagePath,
        ),
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              _showRemoveBodyPartDialog(bodyPart);
            },
          ),
        ),
      ],
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
    Get.dialog(
      AlertDialog(
        title: Text('Add Body Part'),
        content: TextField(
          controller: _bodyPartController,
          decoration: InputDecoration(hintText: 'Enter Body Part'),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Get.back();
            },
          ),
          TextButton(
            child: Text('Add'),
            onPressed: () {
              String bodyPart = _bodyPartController.text.trim();
              if (bodyPart.isNotEmpty) {
                _addCustomBodyPart(bodyPart);
                Get.back();
              }
            },
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void _showRemoveBodyPartDialog(String bodyPart) {
    Get.defaultDialog(
      title: 'Remove Body Part',
      content: Text('Are you sure you want to remove $bodyPart?'),
      textConfirm: 'Remove',
      confirmTextColor: Colors.white,
      onConfirm: () {
        _removeCustomBodyPart(bodyPart);
        Get.back();
      },
      textCancel: 'Cancel',
      onCancel: () {},
    );
  }

  void _addCustomBodyPart(String bodyPart) {
    _userDataViewModel.addCustomBodyPart(bodyPart);
  }

  void _removeCustomBodyPart(String bodyPart) {
    _userDataViewModel.removeCustomBodyPart(bodyPart);
  }
}
