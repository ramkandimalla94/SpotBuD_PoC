import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotbud/viewmodels/userdata_viewmodel.dart';
import 'package:your_app_name/ui/viewmodels/name_viewmodel.dart';

class HomeView extends StatelessWidget {
  final NameViewModel _nameViewModel = Get.put(NameViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(
            'Home, ${_nameViewModel.firstName} ${_nameViewModel.lastName}')),
        centerTitle: true,
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            Expanded(
              child: TabBarView(
                children: [
                  Center(
                    child: Text('Log Workout Tab'),
                  ),
                  Center(
                    child: Text('History Tab'),
                  ),
                  Center(
                    child: Text('Progress Tracker Tab'),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.blue,
              child: TabBar(
                tabs: [
                  Tab(
                    icon: Icon(Icons.directions_run),
                    text: 'Log Workout',
                  ),
                  Tab(
                    icon: Icon(Icons.history),
                    text: 'History',
                  ),
                  Tab(
                    icon: Icon(Icons.timeline),
                    text: 'Progress Tracker',
                  ),
                ],
              ),
            ),
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