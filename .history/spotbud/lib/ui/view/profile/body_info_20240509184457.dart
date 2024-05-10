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
      body: Column(
        children: [
           Row(
                      children: [
                        Text(
                          'Height ',
                          style: const TextStyle(
                              fontSize: 18,
                              color: AppColors.backgroundColor,
                              fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Obx(
                          () => Text(
                            '$${_userDataViewModel.feet.value} ft ${_userDataViewModel.inches.value}',
                            style: const TextStyle(
                              fontSize: 18,
                              color: AppColors.backgroundColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
          Obx(
            () => Text(
              'Height: ${_userDataViewModel.feet.value} ft ${_userDataViewModel.inches.value} in',
              style: const TextStyle(
                fontSize: 20,
                color: AppColors.secondaryColor,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Obx(
            () => Text(
              'Weight: ${_userDataViewModel.convertWeightIfNeeded(_userDataViewModel.weight.value)} ${_userDataViewModel.getDisplayWeightUnit()}',
              style: const TextStyle(
                fontSize: 20,
                color: AppColors.secondaryColor,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Obx(() {
            String genderString =
                _userDataViewModel.gender.value.toString().split('.')[1];
            return Text(
              'Gender: $genderString',
              style: const TextStyle(
                fontSize: 20,
                color: AppColors.secondaryColor,
              ),
            );
          }),
          const SizedBox(height: 10),
          Obx(() {
            String lifestyleString =
                _userDataViewModel.lifestyle.value.toString().split('.')[1];
            return Text(
              'Lifestyle: $lifestyleString',
              style: const TextStyle(
                fontSize: 20,
                color: AppColors.secondaryColor,
              ),
            );
          }),
        ],
      ),
    );
  }
}