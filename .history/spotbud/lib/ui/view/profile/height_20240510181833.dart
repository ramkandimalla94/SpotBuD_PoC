import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/ui/widgets/button.dart';
import 'package:spotbud/viewmodels/user_data_viewmodel.dart';

class HeightSettingScreen extends StatefulWidget {
  @override
  _HeightSettingScreenState createState() => _HeightSettingScreenState();
}

class _HeightSettingScreenState extends State<HeightSettingScreen> {
  int feet = 0;
  int inches = 0;
  double heightMeters = 0.0;
  final UserDataViewModel _userDataViewModel = Get.put(UserDataViewModel());
  bool _useFeetAndInches = true; // Default to using feet and inches

  void updatePreview() {
    setState(() {
      if (_useFeetAndInches) {
        int totalInches = feet * 12 + inches;
        heightMeters = totalInches * 0.0254;
      } else {
        double totalInches = heightMeters * 39.3701;
        feet = (totalInches / 12).floor();
        inches = (totalInches % 12).floor();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text('Set Height'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Height Unit:'),
                DropdownButton<bool>(
                  value: _useFeetAndInches,
                  onChanged: (bool? value) {
                    setState(() {
                      _useFeetAndInches = value!;
                      updatePreview(); // Update the preview when changing units
                    });
                  },
                  items: [
                    DropdownMenuItem<bool>(
                      value: true,
                      child: Text('Feet & Inches'),
                    ),
                    DropdownMenuItem<bool>(
                      value: false,
                      child: Text('Meters & Centimeters'),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Text('Height:'),
            _useFeetAndInches
                ? Row(
                    children: [
                      Flexible(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(labelText: 'Feet'),
                          onChanged: (value) {
                            setState(() {
                              feet = int.tryParse(value) ?? 0;
                              updatePreview(); // Update the preview when entering new values
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      Flexible(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(labelText: 'Inches'),
                          onChanged: (value) {
                            setState(() {
                              inches = int.tryParse(value) ?? 0;
                              updatePreview(); // Update the preview when entering new values
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Preview:'),
                          Text('${heightMeters.toStringAsFixed(2)} meters '),
                        ],
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Flexible(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(labelText: 'Meters'),
                          onChanged: (value) {
                            setState(() {
                              heightMeters = double.tryParse(value) ?? 0;
                              updatePreview(); // Update the preview when entering new values
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Preview:'),
                          Text('${feet} feet ${inches} inches'),
                        ],
                      ),
                    ],
                  ),
            SizedBox(height: 20),
            Center(
              child: buildLoginButton(
                onPressed: () {
                  // Perform checks and validations
                  if (feet > 0 && inches >= 0 && inches < 12) {
                    // Call updateHeight function from ViewModel
                    _userDataViewModel.updateHeight(feet, inches);
                    Navigator.pop(context); // Close the Height screen
                  } else {
                    // Show error message or handle invalid input
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Invalid Input'),
                          content: Text('Please enter valid height values.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                text: 'Save',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
