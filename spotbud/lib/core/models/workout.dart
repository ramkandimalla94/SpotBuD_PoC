class Workout {
  final String id;
  final String date;
  final String endTime;
  final String startTime;
  final List<Exercise> exercises;

  Workout({
    required this.id,
    required this.date,
    required this.endTime,
    required this.startTime,
    required this.exercises,
  });
}

class Exercise {
  final String bodyPart;
  final String machine;
  final List<ExerciseSet> sets;

  Exercise({
    required this.bodyPart,
    required this.machine,
    required this.sets,
  });
}

class ExerciseSet {
  final String reps;
  final String weight;
  final String notes;

  ExerciseSet({
    required this.reps,
    required this.weight,
    required this.notes,
  });
}
