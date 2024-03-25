import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/ui/widgets/button.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';
import 'package:spotbud/ui/widgets/text.dart';
import 'package:spotbud/viewmodels/user_data_viewmodel.dart';

class HomeView extends StatefulWidget {
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final NameViewModel _nameViewModel = Get.put(NameViewModel());

  @override
  void initState() {
    super.initState();
    _nameViewModel.fetchUserNames();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              'Hi,',
              style: AppTheme.primaryText(
                size: 32.0,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              '${_nameViewModel.firstName} ${_nameViewModel.lastName}',
              style: AppTheme.secondaryText(
                size: 35.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          buildLoginButton(
              text: 'text', onPressed: () {}, height: 200, width: 400),
          buildLoginButton(
              text: 'text', onPressed: () {}, height: 200, width: 400),
          buildLoginButton(
              text: 'text', onPressed: () {}, height: 200, width: 400)
        ],
      ),
    );
  }
}