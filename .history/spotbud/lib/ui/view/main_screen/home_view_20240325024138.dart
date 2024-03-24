import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      children: [
        SizedBox(
          height: 20,
        ),
        Padding(
            padding: const EdgeInsets.only(
              top: 16.0,
            ),
            child: Text(
              'Hi,',
              style: AppTheme.primaryText(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            )),
        Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 16),
            child: Text(
              ' ${_nameViewModel.firstName} ${_nameViewModel.lastName}',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            )),
      ],
    ));
  }
}
