class HistoryView extends StatelessWidget {
  final UserDataViewModel userDataViewModel = Get.find();

  DateTime? startDate;
  DateTime? endDate;
  String? bodyPart;
  String? exerciseName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout History'),
      ),
      body: FutureBuilder(
        future: userDataViewModel.fetchWorkoutHistory(
          startDate: startDate,
          endDate: endDate,
          bodyPart: bodyPart,
          exerciseName: exerciseName,
        ),
        builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          // Existing code...
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show filter dialog
          _showFilterDialog(context);
        },
        child: Icon(Icons.filter_list),
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Filter History'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Start Date'),
                SizedBox(height: 8),
                InkWell(
                  onTap: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: startDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (selectedDate != null) {
                      startDate = selectedDate;
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(startDate != null
                            ? DateFormat('yyyy-MM-dd').format(startDate!)
                            : 'Select date'),
                        Icon(Icons.calendar_today),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                // Similar fields for End Date, Body Part, and Exercise Name
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Refresh history with applied filters
                Get.find<UserDataViewModel>().update();
              },
              child: Text('Apply'),
            ),
          ],
        );
      },
    );
  }
}
