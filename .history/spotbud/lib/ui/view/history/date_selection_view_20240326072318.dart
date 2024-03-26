import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Ensure you have imported Get package
// Import the history page

class DateSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Workout Date'),
      ),
      body: ListView.builder(
       
        itemBuilder: (context, index) {
          // Get the date for this index and format it as needed
          DateTime date = // Get date at index
          String formattedDate = DateFormat.yMMMd().format(date);
          return ListTile(
            title: Text(formattedDate),
            onTap: () {
              // Navigate to workout history page for the selected date
              Get.to(HistoryPage(selectedDate: date));
            },
          );
        },
         itemCount: // Calculate number of dates,
      ),
    );
  }
}
