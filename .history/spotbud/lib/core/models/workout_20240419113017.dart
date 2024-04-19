import 'package:cloud_firestore/cloud_firestore.dart';

class Exercise {
  final String name;
  final List<ExerciseSet> sets;

  Exercise({
    required this.name,
    required this.sets,
  });

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      name: map['name'],
      sets: List<ExerciseSet>.from(
        map['sets'].map((set) => ExerciseSet.fromMap(set)),
      ),
    );
  }
}

class ExerciseSet {
  final int reps;
  final double weight;

  ExerciseSet({
    required this.reps,
    required this.weight,
  });

  factory ExerciseSet.fromMap(Map<String, dynamic> map) {
    return ExerciseSet(
      reps: map['reps'],
      weight: map['weight'],
    );
  }
}

class Workout {
  final Timestamp timestamp;
  final List<Exercise> exercises;

  Workout({
    required this.timestamp,
    required this.exercises,
  });

  factory Workout.fromMap(Map<String, dynamic> map) {
    return Workout(
      timestamp: map['timestamp'],
      exercises: List<Exercise>.from(
        map['exercises'].map((exercise) => Exercise.fromMap(exercise)),
      ),
    );
  }
}
