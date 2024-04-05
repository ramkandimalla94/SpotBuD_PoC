import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/ui/widgets/custom_loading_indicator.dart';
import 'package:spotbud/viewmodels/user_data_viewmodel.dart';

class BodyPartSelectionScreen extends StatelessWidget {
  final UserDataViewModel _userDataViewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Body Part'),
      ),
      body: GetBuilder<UserDataViewModel>(
        builder: (controller) {
          return controller.bodyParts.isNotEmpty
              ? ListView.builder(
                  itemCount: controller.bodyParts.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(controller.bodyParts[index]),
                      onTap: () {
                        _startWorkoutSession(controller.bodyParts[index]);
                      },
                    );
                  },
                )
              : Center(child: LoadingIndicator());
        },
      ),
    );
  }

  void _startWorkoutSession(String bodyPart) {
    Get.to(() => WorkoutSessionScreen(bodyPart: bodyPart));
  }
}
