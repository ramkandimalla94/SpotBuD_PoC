import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/ui/view/body_details_profile/edit_details/gender.dart';
import 'package:spotbud/ui/view/body_details_profile/edit_details/height.dart';
import 'package:spotbud/ui/view/body_details_profile/edit_details/lifestyle.dart';
import 'package:spotbud/ui/view/body_details_profile/edit_details/weight.dart';
import 'package:spotbud/ui/widgets/assets.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';
import 'package:spotbud/ui/widgets/text.dart';
import 'package:spotbud/viewmodels/user_data_viewmodel.dart';

class BodyInfo extends StatefulWidget {
  const BodyInfo({super.key});

  @override
  State<BodyInfo> createState() => _BodyInfoState();
}

class _BodyInfoState extends State<BodyInfo> {
  final UserDataViewModel _userDataViewModel = Get.put(UserDataViewModel());
  double bmi = 0.0; // Declare bmi as a class variable

  void _updateBMI() {
    double heightInMeters = (_userDataViewModel.feet.value * 0.3048) +
        (_userDataViewModel.inches.value * 0.0254);
    double weightInKg = _userDataViewModel.weight.value;
    bmi = calculateBMI(weightInKg, heightInMeters);
  }

  double calculateBMI(double weight, double height) {
    // Calculate BMI using weight in kilograms and height in meters
    return weight / (height * height);
  }

  void refreshBMI() {
    setState(() {
      _updateBMI(); // Calculate updated BMI
    });
  }

  Color getBMIColor(double bmi) {
    if (bmi < 18.5) {
      return Colors.blue; // Underweight
    } else if (bmi >= 18.5 && bmi < 25) {
      return Colors.green; // Normal weight
    } else if (bmi >= 25 && bmi < 30) {
      return Colors.orange; // Overweight
    } else {
      return Colors.red; // Obese
    }
  }

  String getBMICategory(double bmi) {
    if (bmi < 18.5) {
      return 'Underweight';
    } else if (bmi >= 18.5 && bmi < 25) {
      return 'Normal weight';
    } else if (bmi >= 25 && bmi < 30) {
      return 'Overweight';
    } else {
      return 'Obese';
    }
  }

  void showBMIDialog() {
    TextEditingController heightController = TextEditingController();
    TextEditingController weightController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('BMI Calculator'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: heightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Enter Height (meters)'),
              ),
              TextField(
                controller: weightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Enter Weight (kg)'),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      double height =
                          double.tryParse(heightController.text) ?? 0;
                      double weight =
                          double.tryParse(weightController.text) ?? 0;
                      double bmi = calculateBMI(weight, height);
                      Color bmiColor = getBMIColor(bmi);
                      String bmiCategory = getBMICategory(bmi);

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('BMI Result'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Your BMI is: ${bmi.toStringAsFixed(2)}',
                                  style: TextStyle(color: bmiColor),
                                ),
                                Text(
                                  'BMI Category: $bmiCategory',
                                  style: TextStyle(color: bmiColor),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('Close'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text('Calculate BMI'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the BMI calculator dialog
                    },
                    child: Text('Cancel'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double heightInMeters = (_userDataViewModel.feet.value * 0.3048) +
        (_userDataViewModel.inches.value * 0.0254);
    double weightInKg = _userDataViewModel.weight.value;
    double bmi = calculateBMI(weightInKg, heightInMeters);
    Color bmiColor = getBMIColor(bmi);
    String bmiCategory = getBMICategory(bmi);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Body Details",
          style: AppTheme.primaryText(
            size: 27,
            color: AppColors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: IconThemeData(
          color: AppColors.black, // Adjust the back button color here
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed('/bodydetail');
            },
            icon: const Icon(
              Icons.edit,
              color: AppColors.black,
            ),
          )
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 40),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor:
                      Colors.yellow, // Yellow circular border color
                  radius: 32, // Adjust the radius as needed
                  child: CircleAvatar(
                    radius: 30, // Adjust the radius to fit within the border
                    backgroundColor: Theme.of(context).colorScheme.background,
                    backgroundImage: AssetImage(
                        AppAssets.girlyoga), // Provide the path to your image
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text(
                  'Height : ',
                  style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold),
                ),
                Obx(
                  () => Text(
                    '${_userDataViewModel.feet.value} ft ${_userDataViewModel.inches.value} inches',
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
                Spacer(),
                IconButton(
                  onPressed: () {
                    Get.to(HeightSettingScreen());
                  },
                  icon: Icon(
                    Icons.edit,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Text(
                  'Weight : ',
                  style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold),
                ),
                Obx(
                  () => Text(
                    '${_userDataViewModel.convertWeightIfNeeded(_userDataViewModel.weight.value)} ${_userDataViewModel.getDisplayWeightUnit()}',
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
                Spacer(),
                IconButton(
                  onPressed: () {
                    Get.to(WeightSettingScreen());
                  },
                  icon: Icon(
                    Icons.edit,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Text(
                  'Gender : ',
                  style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold),
                ),
                Obx(() {
                  String genderString =
                      _userDataViewModel.gender.value.toString().split('.')[1];
                  return Text(
                    genderString,
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  );
                }),
                Spacer(),
                IconButton(
                  onPressed: () {
                    Get.to(GenderSelectionScreen());
                  },
                  icon: Icon(
                    Icons.edit,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Text(
                  'Lifestyle : ',
                  style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold),
                ),
                Obx(() {
                  String lifestyleString = _userDataViewModel.lifestyle.value
                      .toString()
                      .split('.')[1];
                  return Text(
                    lifestyleString,
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  );
                }),
                Spacer(),
                IconButton(
                  onPressed: () {
                    Get.to(LifestyleSelectionScreen());
                  },
                  icon: Icon(
                    Icons.edit,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Text(
                  'BMI : ',
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  bmi.toStringAsFixed(1), // Display BMI with one decimal place
                  style: TextStyle(
                    fontSize: 18,
                    color: bmiColor, // Use color based on BMI category
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  ' ($bmiCategory)',
                  style: TextStyle(
                    fontSize: 18,
                    color: bmiColor,
                  ),
                ),
                Spacer(),
                IconButton(
                  onPressed:
                      refreshBMI, // Call refreshBMI when button is pressed
                  icon: Icon(
                    Icons.refresh,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showBMIDialog(); // Call showBMIDialog here
                  },
                  icon: Icon(
                    Icons
                        .calculate_outlined, // You can choose an appropriate BMI calculator icon
                    color: Theme.of(context).colorScheme.primary,
                  ),
                )
              ],
            ),
            Text(
              'Disclaimer: The BMI index calculation is based on mathematical formulas and is for informational purposes only. Consult a healthcare professional for accurate assessment and advice.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
