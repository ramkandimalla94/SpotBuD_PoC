import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for TextInputFormatter
import 'package:get/get.dart';
import 'package:spotbud/core/models/gender.dart';
import 'package:spotbud/ui/widgets/assets.dart';
import 'package:spotbud/ui/widgets/button.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';
import 'package:spotbud/ui/widgets/text.dart';
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

  TextEditingController weightController = TextEditingController();
  TextEditingController feetController = TextEditingController();
  TextEditingController inchesController = TextEditingController();
  TextEditingController metersController = TextEditingController();

  @override
  void initState() {
    super.initState();
    weightController.text = '';
    feetController.text = '';
    inchesController.text = '';
    metersController.text = '';
  }

  @override
  void dispose() {
    weightController.dispose();
    feetController.dispose();
    inchesController.dispose();
    metersController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        leading: Icon(Icons.cancel_outlined),
        iconTheme: IconThemeData(color: AppColors.backgroundColor),
        backgroundColor: AppColors.primaryColor,
        title: Text(
          'User Information',
          style: AppTheme.secondaryText(
            fontWeight: FontWeight.bold,
            color: AppColors.backgroundColor,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Enter Weight:',
                    style: AppTheme.primaryText(
                      color: AppColors.acccentColor,
                      fontWeight: FontWeight.bold,
                      size: 30,
                    ),
                  ),
                  Image.asset(
                    AppAssets.weight, // Path to your weight GIF
                    width: 75,
                    height: 75,
                  ),
                ],
              ),
              // Weight input
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextField(
                      controller: weightController,
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d*$'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          if (selectedUnit.value == WeightUnit.lbs) {
                            updateWeightKg(double.parse(value));
                          } else {
                            updateWeightLbs(double.parse(value));
                          }
                        }
                      },
                      style: TextStyle(
                        color: AppColors.acccentColor,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Weight',
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Expanded(
                    flex: 1,
                    child: DropdownButton<WeightUnit>(
                      dropdownColor: AppColors.primaryColor,
                      value: selectedUnit.value,
                      onChanged: (value) {
                        setState(() {
                          selectedUnit.value = value!;
                          if (value == WeightUnit.lbs) {
                            updateWeightLbs(weightKg.value);
                          } else {
                            updateWeightKg(weightLbs.value);
                          }
                          // Clear text field
                          weightController.text = '';
                        });
                      },
                      items: WeightUnit.values.map((unit) {
                        return DropdownMenuItem<WeightUnit>(
                          value: unit,
                          child: Text(
                            unit.toString().split('.').last,
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              // Display weight
              Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Obx(() => Text(
                            'Weight (lbs): ${weightLbs.value.toStringAsFixed(2)}',
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                    SizedBox(width: 10.0),
                    Expanded(
                      child: Obx(() => Text(
                            'Weight (kg): ${weightKg.value.toStringAsFixed(2)}',
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Enter Height:',
                    style: AppTheme.primaryText(
                      color: AppColors.acccentColor,
                      fontWeight: FontWeight.bold,
                      size: 30,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.0),
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
                      backgroundColor: isFeetInches.value
                          ? AppColors.acccentColor
                          : Colors.grey[400],
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
                    child: Text(
                      'Meters & Centimeters',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: !isFeetInches.value
                          ? AppColors.acccentColor
                          : Colors.grey[400],
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
              Text(
                'Height: ${_formatHeight()}',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20.0),
              Text(
                'Select Gender:',
                style: AppTheme.primaryText(
                  color: AppColors.acccentColor,
                  fontWeight: FontWeight.bold,
                  size: 30,
                ),
              ),
              // Gender selection
              Obx(
                () => DropdownButton<Gender>(
                  dropdownColor: AppColors.primaryColor,
                  value: userDataViewModel.gender.value,
                  onChanged: (value) {
                    setState(() {
                      userDataViewModel.gender.value = value!;
                    });
                  },
                  items: Gender.values.map((gender) {
                    return DropdownMenuItem<Gender>(
                      value: gender,
                      child: Text(
                        gender.toString().split('.').last,
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 20.0),
              // Save button
              Center(
                child: buildLoginButton(
                  onPressed: () {
                    // Check if any of the text fields are empty
                    if (weightController.text.isEmpty ||
                        (isFeetInches.value &&
                            (feetController.text.isEmpty ||
                                inchesController.text.isEmpty)) ||
                        (!isFeetInches.value &&
                            metersController.text.isEmpty)) {
                      // Show a snackbar or any other feedback to inform the user
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: AppColors.acccentColor,
                          content: Text(
                            'Please fill in all fields.',
                            style: TextStyle(color: AppColors.black),
                          ),
                        ),
                      );
                    } else {
                      // All fields are filled, proceed with saving
                      userDataViewModel.saveBodyDetails(
                        weightKg.value,
                        feet,
                        inches,
                        userDataViewModel.gender.value,
                        true,
                      );
                      Get.toNamed('/mainscreen');
                    }
                  },
                  text: 'Save',
                ),
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
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                  RegExp(r'^\d*$')) // Allow only numbers
            ],
            onChanged: (value) {
              setState(() {
                feet = int.parse(value);
                updateHeight();
              });
            },
            style: TextStyle(
                color:
                    AppColors.acccentColor), // Set text color of entered value
            decoration: InputDecoration(
              hintText: 'feet',
              hintStyle: TextStyle(color: Colors.white), // Set hint text color
            ),
          ),
        ),
        SizedBox(width: 10.0),
        Text(
          'ft',
          style: TextStyle(color: Colors.white),
        ),
        SizedBox(width: 10.0),
        Expanded(
          child: TextField(
            controller: inchesController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                  RegExp(r'^\d*$')) // Allow only numbers
            ],
            onChanged: (value) {
              setState(() {
                inches = int.parse(value);
                updateHeight();
              });
            },
            style: TextStyle(
                color:
                    AppColors.acccentColor), // Set text color of entered value
            decoration: InputDecoration(
              hintText: 'inches',
              hintStyle: TextStyle(color: Colors.white), // Set hint text color
            ),
          ),
        ),
        SizedBox(width: 10.0),
        Text(
          'in',
          style: TextStyle(color: Colors.white),
        ),
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
            keyboardType: TextInputType.numberWithOptions(
                decimal: true), // Allow only numbers and .
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))
            ], // Allow only numbers and .
            onChanged: (value) {
              setState(() {
                heightMeters = double.parse(value);
                updateFeetAndInches(); // Update feet and inches
              });
            },
            style: TextStyle(
                color:
                    AppColors.acccentColor), // Set text color of entered value
            decoration: InputDecoration(
              hintText: 'Height in Meter',
              hintStyle: TextStyle(color: Colors.white), // Set hint text color
            ),
          ),
        ),
        SizedBox(width: 10.0),
        Text(
          'm',
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  // Method to update feet and inches based on height in meters
  void updateFeetAndInches() {
    int totalInches = (heightMeters * 39.3701).toInt();
    feet = totalInches ~/ 12;
    inches = totalInches % 12;
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
