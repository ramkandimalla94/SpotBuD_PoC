import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/ui/view/profile/height.dart';
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
  @override
  Widget build(BuildContext context) {
    double heightInMeters = (_userDataViewModel.feet.value * 0.3048) +
        (_userDataViewModel.inches.value * 0.0254);
    double weightInKg = _userDataViewModel.weight.value;
    double bmi = calculateBMI(weightInKg, heightInMeters);
    Color bmiColor = getBMIColor(bmi);

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
              Get.to(Height());
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
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
        child: Column(
          children: [
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
                    Get.to(Height());
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
                    Get.toNamed('/bodydetail');
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
                    Get.toNamed('/bodydetail');
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
                    Get.toNamed('/bodydetail');
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
          ],
        ),
      ),
    );
  }
}
