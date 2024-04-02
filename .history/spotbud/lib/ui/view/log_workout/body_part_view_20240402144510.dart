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
              fontWeight: FontWeight.w500, color: AppColors.acccentColor),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Fetch data again from the database
          await _userDataViewModel.getBodyParts();
        },
        child: SingleChildScrollView(
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddBodyPartDialog(context);
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

  void _handleBodyPartSelection(String bodyPart) {
    // Navigate to machine selection screen and pass the selected body part
    Get.to(() => MachineSelectionScreen(bodyPart: bodyPart));
  }

  void _showAddBodyPartDialog(BuildContext context) {
    TextEditingController _bodyPartController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Body Part'),
          content: TextField(
            controller: _bodyPartController,
            decoration: InputDecoration(hintText: 'Enter Body Part'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                String bodyPart = _bodyPartController.text.trim();
                if (bodyPart.isNotEmpty) {
                  _addCustomBodyPart(bodyPart);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _addCustomBodyPart(String bodyPart) {
    _userDataViewModel.addCustomBodyPart(bodyPart);
    _userDataViewModel.update();
  }
}
