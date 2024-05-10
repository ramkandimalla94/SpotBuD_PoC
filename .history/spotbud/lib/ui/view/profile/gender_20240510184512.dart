import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';
import 'package:spotbud/viewmodels/user_data_viewmodel.dart';

enum Gender { male, female, others }

class GenderSelectionScreen extends StatefulWidget {
  const GenderSelectionScreen({Key? key}) : super(key: key);

  @override
  _GenderSelectionScreenState createState() => _GenderSelectionScreenState();
}

class _GenderSelectionScreenState extends State<GenderSelectionScreen> {
  Gender? selectedGender;
  final UserDataViewModel _userDataViewModel = Get.put(UserDataViewModel());
  void selectGender(Gender gender) {
    setState(() {
      selectedGender = gender;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Gender'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: IconThemeData(color: AppColors.black),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => selectGender(Gender.male),
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/images/male.png'),
                    fit: BoxFit.cover,
                  ),
                  border: Border.all(
                    color: selectedGender == Gender.male
                        ? Colors.blue
                        : Colors.grey[200]!,
                    width: 3,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () => selectGender(Gender.female),
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/images/female.png'),
                    fit: BoxFit.cover,
                  ),
                  border: Border.all(
                    color: selectedGender == Gender.female
                        ? Colors.pink
                        : Colors.grey[200]!,
                    width: 3,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: selectedGender != null
                  ? _userDataViewModel.saveGender(selectedGender)
                  : null,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
