import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
        centerTitle: true,
        backgroundColor: AppColors.acccentColor,
      ),
      backgroundColor: AppColors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'Height : ',
                  style: const TextStyle(
                      fontSize: 18,
                      color: AppColors.backgroundColor,
                      fontWeight: FontWeight.bold),
                ),
                Obx(
                  () => Text(
                    '${_userDataViewModel.feet.value} ft ${_userDataViewModel.inches.value} inches',
                    style: const TextStyle(
                      fontSize: 18,
                      color: AppColors.backgroundColor,
                    ),
                  ),
                ),
                Spacer(),
                IconButton(
                  onPressed: () {
                    Get.toNamed('/bodydetail');
                  },
                  icon: const Icon(
                    Icons.edit,
                    color: AppColors.acccentColor,
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
                  style: const TextStyle(
                      fontSize: 18,
                      color: AppColors.backgroundColor,
                      fontWeight: FontWeight.bold),
                ),
                Obx(
                  () => Text(
                    '${_userDataViewModel.convertWeightIfNeeded(_userDataViewModel.weight.value)} ${_userDataViewModel.getDisplayWeightUnit()}',
                    style: const TextStyle(
                      fontSize: 18,
                      color: AppColors.backgroundColor,
                    ),
                  ),
                ),
                Spacer(),
                IconButton(
                  onPressed: () {
                    Get.toNamed('/bodydetail');
                  },
                  icon: const Icon(
                    Icons.edit,
                    color: AppColors.acccentColor,
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
                  'Gender ',
                  style: const TextStyle(
                      fontSize: 18,
                      color: AppColors.backgroundColor,
                      fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Obx(() {
                  String genderString =
                      _userDataViewModel.gender.value.toString().split('.')[1];
                  return Text(
                    genderString,
                    style: const TextStyle(
                      fontSize: 18,
                      color: AppColors.backgroundColor,
                    ),
                  );
                }),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Text(
                  'Lifestyle ',
                  style: const TextStyle(
                      fontSize: 18,
                      color: AppColors.backgroundColor,
                      fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Obx(() {
                  String lifestyleString = _userDataViewModel.lifestyle.value
                      .toString()
                      .split('.')[1];
                  return Text(
                    lifestyleString,
                    style: const TextStyle(
                      fontSize: 18,
                      color: AppColors.backgroundColor,
                    ),
                  );
                }),
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
