import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/core/models/gender.dart';
import 'package:spotbud/viewmodels/user_data_viewmodel.dart';

class UserInfoPage extends StatefulWidget {
  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  final RxDouble weightLbs = 0.0.obs;
  final RxDouble weightKg = 0.0.obs;
  final Rx<WeightUnit> selectedUnit = WeightUnit.lbs.obs;
  final RxBool isFeetInches = true
      .obs; // Indicates whether height is in feet and inches or meters and centimeters
  final UserDataViewModel userDataViewModel = Get.put(UserDataViewModel());

  int feet = 0;
  int inches = 0;
  double heightMeters = 0.0; // Updated to double
  int heightCentimeters = 0;

  TextEditingController feetController = TextEditingController();
  TextEditingController inchesController = TextEditingController();
  TextEditingController metersController = TextEditingController();

  @override
  void initState() {
    super.initState();
    feetController.text = '';
    inchesController.text = '';
    metersController.text = '';
  }

  @override
  void dispose() {
    feetController.dispose();
    inchesController.dispose();
    metersController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Information'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Enter Weight:'),
              // Weight input
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        if (selectedUnit.value == WeightUnit.lbs) {
                          updateWeightKg(double.parse(value));
                        } else {
                          updateWeightLbs(double.parse(value));
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Expanded(
                    flex: 1,
                    child: DropdownButton<WeightUnit>(
                      value: selectedUnit.value,
                      onChanged: (value) {
                        setState(() {
                          selectedUnit.value = value!;
                          if (value == WeightUnit.lbs) {
                            updateWeightLbs(weightKg.value);
                          } else {
                            updateWeightKg(weightLbs.value);
                          }
                          // Clear text fields
                          feetController.text = '';
                          inchesController.text = '';
                          metersController.text = '';
                        });
                      },
                      items: WeightUnit.values.map((unit) {
                        return DropdownMenuItem<WeightUnit>(
                          value: unit,
                          child: Text(unit.toString().split('.').last),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              // Display weight
              Row(
                children: [
                  Expanded(
                    child: Obx(() => Text(
                        'Weight (lbs): ${weightLbs.value.toStringAsFixed(2)}')),
                  ),
                  SizedBox(width: 10.0),
                  Expanded(
                    child: Obx(() => Text(
                        'Weight (kg): ${weightKg.value.toStringAsFixed(2)}')),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Text('Enter Height:'),
              // Height input toggle
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isFeetInches.value = true;
                        // Clear text fields
                        feetController.text = '';
                        inchesController.text = '';
                        metersController.text = '';
                      });
                    },
                    child: Text('Feet & Inches'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isFeetInches.value ? Colors.blue : Colors.grey[400],
                    ),
                  ),
                  SizedBox(width: 10.0),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isFeetInches.value = false;
                        // Clear text fields
                        feetController.text = '';
                        inchesController.text = '';
                        metersController.text = '';
                      });
                    },
                    child: Text('Meters & Centimeters'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          !isFeetInches.value ? Colors.blue : Colors.grey[400],
                    ),
                  ),
                ],
              ),
              // Height input based on toggle selection
              isFeetInches.value
                  ? _buildFeetInchesInput()
                  : _buildMetersCentimetersInput(),
              SizedBox(height: 20.0),
              // Display height
              Text('Height: ${_formatHeight()}'),
              SizedBox(height: 20.0),
              Text('Select Gender:'),
              // Gender selection
              Obx(
                () => DropdownButton<Gender>(
                  value: userDataViewModel.gender.value,
                  onChanged: (value) {
                    setState(() {
                      userDataViewModel.gender.value = value!;
                    });
                  },
                  items: Gender.values.map((gender) {
                    return DropdownMenuItem<Gender>(
                      value: gender,
                      child: Text(gender.toString().split('.').last),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 20.0),
              // Save button
              ElevatedButton(
                onPressed: () {
                  userDataViewModel.saveBodyDetails(
                    (selectedUnit.value == WeightUnit.lbs)
                        ? weightLbs.value
                        : weightKg.value,
                    feet,
                    inches,
                    userDataViewModel.gender.value,
                  );
                  Get.toNamed('/mainscreen');
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to update weight in kg
  void updateWeightKg(double newWeightLbs) {
    weightLbs.value = newWeightLbs;
    weightKg.value = newWeightLbs * 0.453592;
  }

  // Method to update weight in lbs
  void updateWeightLbs(double newWeightKg) {
    weightKg.value = newWeightKg;
    weightLbs.value = newWeightKg / 0.453592;
  }

  // Method to update height in meters and centimeters
  void updateHeight() {
    if (isFeetInches.value) {
      int totalInches = (feet * 12) + inches;
      heightMeters = totalInches * 0.0254; // 1 inch = 0.0254 meters
      heightCentimeters = (heightMeters * 100).round();
    }
  }

  // Build input fields for height in feet and inches
  Widget _buildFeetInchesInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: feetController,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                feet = int.parse(value);
                updateHeight();
              });
            },
          ),
        ),
        SizedBox(width: 10.0),
        Text('ft'),
        SizedBox(width: 10.0),
        Expanded(
          child: TextField(
            controller: inchesController,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                inches = int.parse(value);
                updateHeight();
              });
            },
          ),
        ),
        SizedBox(width: 10.0),
        Text('in'),
      ],
    );
  }

  // Build input fields for height in meters and centimeters
  Widget _buildMetersCentimetersInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: metersController,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                heightMeters = double.parse(value);
              });
            },
          ),
        ),
        SizedBox(width: 10.0),
        Text('m'),
      ],
    );
  }

  // Format height
  String _formatHeight() {
    if (isFeetInches.value) {
      return '${heightMeters.toStringAsFixed(2)} meters';
    } else {
      int totalInches = (heightMeters * 39.3701).toInt();
      int feet = totalInches ~/ 12;
      int inches = totalInches % 12;
      return '$feet feet $inches inches';
    }
  }
}

enum WeightUnit {
  lbs,
  kg,
}
