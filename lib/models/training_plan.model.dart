import 'dart:convert';

import 'exercise.model.dart';

class TrainingPlan {
  String? id;
  String? name;
  String? description;
  List<Exercise> exercises = [];

  TrainingPlan({this.name, this.description});

  factory TrainingPlan.formJson({
    required dynamic trainingPlanJSONObject,
  }) {
    final trainingPlan = TrainingPlan();
    trainingPlan.id = trainingPlanJSONObject["id"].toString();
    trainingPlan.name = trainingPlanJSONObject["name"];
    trainingPlan.description = trainingPlanJSONObject["description"];
    if (trainingPlanJSONObject['exercises'].runtimeType == String) {
      trainingPlan.exercises = List.from(jsonDecode(trainingPlanJSONObject['exercises'])).map((element) => Exercise.fromJson(exerciseJSONObject: element)).toList();
    } else {
      trainingPlan.exercises =
          List.from(trainingPlanJSONObject['exercises']).map((element) =>
              Exercise.fromJson(exerciseJSONObject: element)).toList();
    }
    return trainingPlan;
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> useMap = <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'exercises': jsonEncode(exercises.map((e) => e.toMap()).toList())
    };
    return useMap;
  }
}
