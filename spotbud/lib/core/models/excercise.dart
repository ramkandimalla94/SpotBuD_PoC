class Exercise {
  String name;
  List<ExerciseSet> sets;

  Exercise({required this.name, this.sets = const []});
}

class ExerciseSet {
  String reps;
  String weight;
  String notes;

  ExerciseSet({required this.reps, required this.weight, required this.notes});
}
