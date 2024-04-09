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
  final UserDataViewModel userDataViewModel = Get.put(UserDataViewModel());

  int feet = 0;
  int inches = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Information'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Enter Weight:'),
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
            Text('Enter Height (feet and inches):'),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        feet = int.parse(value);
                      });
                    },
                  ),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        inches = int.parse(value);
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Text('Select Gender:'),
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
    );
  }

  void updateWeightKg(double newWeightLbs) {
    weightLbs.value = newWeightLbs;
    weightKg.value = newWeightLbs * 0.453592;
  }

  void updateWeightLbs(double newWeightKg) {
    weightKg.value = newWeightKg;
    weightLbs.value = newWeightKg / 0.453592;
  }
}

enum WeightUnit {
  lbs,
  kg,
}
