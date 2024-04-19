class Workout {
  final String id;
  final String name;
  final List<Exercise> exercises;

  Workout({
    required this.id,
    required this.name,
    required this.exercises,
    required timestamp,
  });

  factory Workout.fromMap(Map<String, dynamic> map) {
    return Workout(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      exercises: List<Exercise>.from(
        (map['exercises'] as List<dynamic>).map(
          (exercise) => Exercise.fromMap(exercise),
        ),
      ),
    );
  }
}

class Exercise {
  final String name;
  final List<Set> sets;

  Exercise({
    required this.name,
    required this.sets,
  });

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      name: map['name'] ?? '',
      sets: List<Set>.from(
        (map['sets'] as List<dynamic>).map(
          (set) => Set.fromMap(set),
        ),
      ),
    );
  }
}

class Set {
  final int reps;
  final double weight;

  Set({
    required this.reps,
    required this.weight,
  });

  factory Set.fromMap(Map<String, dynamic> map) {
    return Set(
      reps: map['reps'] ?? 0,
      weight: (map['weight'] ?? 0.0).toDouble(),
    );
  }
}
