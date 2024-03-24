import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            SizedBox(height: 20),
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Hi, ${_nameViewModel.firstName} ${_nameViewModel.lastName}',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                )),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          // Handle bottom navigation bar item tap
          switch (index) {
            case 0:
              // Handle Home navigation
              break;
            case 1:
              // Handle Settings navigation
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
