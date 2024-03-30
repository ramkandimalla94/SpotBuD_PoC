@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bluebackgroundColor,
    appBar: AppBar(
      backgroundColor: AppColors.bluebackgroundColor,
      iconTheme: IconThemeData(color: AppColors.acccentColor),
      title: Text(
        'Workout History ',
        style: AppTheme.primaryText(
            fontWeight: FontWeight.w500, color: AppColors.acccentColor),
      ),
    ),
    body: SingleChildScrollView(
      child: Column(
        children: [
          _buildFilterDropdowns(),
          FutureBuilder(
            future: _userDataViewModel.fetchWorkoutHistory(),
            builder:
                (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                // Filter workout history based on selected body part and machine
                List<Map<String, dynamic>> filteredHistory = snapshot.data!
                    .where((workout) =>
                        (selectedBodyPart == null ||
                            workout['bodyPart'] == selectedBodyPart) &&
                        (selectedMachine == null ||
                            workout['machine'] == selectedMachine))
                    .toList();

                // Sort filtered workout history by date
                filteredHistory
                    .sort((a, b) => b['timestamp'].compareTo(a['timestamp']));

                // Group filtered workout history by date
                Map<DateTime, List<Map<String, dynamic>>> groupedByDate = {};
                filteredHistory.forEach((workout) {
                  DateTime date = workout['timestamp'].toDate();
                  DateTime formattedDate =
                      DateTime(date.year, date.month, date.day);
                  if (groupedByDate.containsKey(formattedDate)) {
                    groupedByDate[formattedDate]!.add(workout);
                  } else {
                    groupedByDate[formattedDate] = [workout];
                  }
                });

                return ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: groupedByDate.entries.map((entry) {
                    return ExpansionTile(
                      title: Text(
                        DateFormat.yMMMd().format(entry.key),
                        style: AppTheme.primaryText(
                            color: AppColors.acccentColor,
                            fontWeight: FontWeight.w500,
                            size: 18),
                      ),
                      trailing: Icon(
                        Icons.arrow_drop_down,
                        color: AppColors.acccentColor,
                      ),
                      children: _buildBodyPartSegments(entry.value),
                    );
                  }).toList(),
                );
              }
            },
          ),
          SizedBox(height: 16), // Add some spacing after the workout history
        ],
      ),
    ),
  );
}
