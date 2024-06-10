import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkoutRoutineScreen extends StatefulWidget {
  @override
  _WorkoutRoutineScreenState createState() => _WorkoutRoutineScreenState();
}

class _WorkoutRoutineScreenState extends State<WorkoutRoutineScreen> {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout Routines'),
      ),
      body: user == null
          ? Center(
              child: Text('You must be logged in to view workout routines.'),
            )
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user!.uid)
                  .collection('routines')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final routines = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: routines.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return ListTile(
                        tileColor: Colors.grey[200],
                        title: Text('Create New Routine'),
                        leading: Icon(Icons.add),
                        onTap: () {
                          Get.to(() => CreateRoutineScreen());
                        },
                      );
                    }

                    final routine = routines[index - 1];
                    final routineName = routine['name'] as String? ?? '';
                    final exercises =
                        routine['exercises'] as List<dynamic>? ?? [];

                    return ListTile(
                      title: Text(routineName),
                      subtitle: Text('${exercises.length} exercises'),
                      trailing: IconButton(
                        icon: Icon(Icons.play_arrow),
                        onPressed: () {
                          // Load the routine exercises into the WorkoutLoggingForm
                          // You'll need to implement this logic
                        },
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
