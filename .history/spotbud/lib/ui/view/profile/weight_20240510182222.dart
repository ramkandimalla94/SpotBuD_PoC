import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';

class WeightSettingScreen extends StatefulWidget {
  const WeightSettingScreen({Key? key}) : super(key: key);

  @override
  _WeightSettingScreenState createState() => _WeightSettingScreenState();
}

class _WeightSettingScreenState extends State<WeightSettingScreen> {
  String selectedUnit = 'kg'; // Default unit

  void updateWeight(double weight) {
    // Logic to update weight in UserDataViewModel
    // You can implement this based on your ViewModel structure
    print('Updated weight: $weight $selectedUnit');
    // For example:
    // _userDataViewModel.updateWeight(weight, selectedUnit);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weight Settings'),
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
                double weight = double.tryParse(value) ?? 0;
                updateWeight(weight);
              },
            ),
          ],
        ),
      ),
    );
  }
}
