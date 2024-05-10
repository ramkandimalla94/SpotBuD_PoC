import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/ui/widgets/button.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';
import 'package:spotbud/ui/widgets/text.dart';
import 'package:spotbud/viewmodels/user_data_viewmodel.dart';

class WeightSettingScreen extends StatefulWidget {
  const WeightSettingScreen({Key? key}) : super(key: key);

  @override
  _WeightSettingScreenState createState() => _WeightSettingScreenState();
}

class _WeightSettingScreenState extends State<WeightSettingScreen> {
  String selectedUnit = 'kg'; // Default unit
  double weight = 0.0;
  final UserDataViewModel _userDataViewModel = Get.put(UserDataViewModel());
  double convertedWeight = 0.0;

  void updateWeight(double newWeight) {
    setState(() {
      weight = newWeight;
      if (selectedUnit == 'kg') {
        // Convert to lbs
        convertedWeight = weight * 2.20462;
      } else {
        // Convert to kg
        convertedWeight = weight * 0.453592;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Set Weight',
          style: AppTheme.primaryText(
            size: 27,
            color: AppColors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: IconThemeData(color: AppColors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Weight Unit:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Radio(
                  value: 'kg',
                  groupValue: selectedUnit,
                  onChanged: (value) {
                    setState(() {
                      selectedUnit = value.toString();
                      updateWeight(weight); // Update converted weight
                    });
                  },
                ),
                Text(
                  'Kilograms (kg)',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Radio(
                  value: 'lbs',
                  groupValue: selectedUnit,
                  onChanged: (value) {
                    setState(() {
                      selectedUnit = value.toString();
                      updateWeight(weight); // Update converted weight
                    });
                  },
                ),
                Text(
                  'Pounds (lbs)',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter Weight',
                suffixText: selectedUnit,
              ),
              onChanged: (value) {
                double newWeight = double.tryParse(value) ?? 0;
                updateWeight(newWeight);
              },
            ),
            SizedBox(height: 10),
            Text(
              'Weight in ${selectedUnit == 'kg' ? 'Pounds (lbs)' : 'Kilograms (kg)'}: ${convertedWeight.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            Center(
              child: buildLoginButton(
                onPressed: () {
                  // Perform checks and validations
                  if (weight >= 0) {
                    // Call updateHeight function from ViewModel
                    _userDataViewModel.saveWeight(weight, selectedUnit);
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
