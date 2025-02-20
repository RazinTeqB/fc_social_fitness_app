import 'package:fc_social_fitness/models/exercise.model.dart';

class WorkoutPlan {
  String? id;
  String? name;
  DateTime? expiresAt;
  String? notes;
  List<Exercise> exercises = [];


  WorkoutPlan({this.name,this.expiresAt, this.notes});

  factory WorkoutPlan.formJson({
    required dynamic workoutPlanJSONObject,
  }) {
    final workoutPlan = WorkoutPlan();
    workoutPlan.id = workoutPlanJSONObject["id"].toString();
    workoutPlan.name = workoutPlanJSONObject["name"];
    workoutPlan.expiresAt = workoutPlanJSONObject["expires_at"] != null
        ? DateTime.parse(workoutPlanJSONObject["expires_at"])
        : null;
    workoutPlan.notes = workoutPlanJSONObject["notes"];
    workoutPlan.exercises = List.from(workoutPlanJSONObject['exercises']).map((element) => Exercise.fromJson(exerciseJSONObject: element)).toList();


    return workoutPlan;
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> useMap = <String, dynamic>{
      'name': name,
      'expires_at': expiresAt,
      'notes' : notes
    };
    return useMap;
  }
}
