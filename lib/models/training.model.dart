import 'dart:convert';

import 'package:fc_social_fitness/models/training_plan.model.dart';
import 'package:fc_social_fitness/utils/app_database.dart';

class Training {
  String? name;
  String? id;
  String? description;
  String? gender;
  String? trainingImage;
  bool favourite = false;
  List<TrainingPlan> trainingPlans = [];

  Training({this.name});

  factory Training.formJson({
    required dynamic trainingJSONObject,
  }) {
    final training = Training();
    training.id = trainingJSONObject["id"].toString();
    training.name = trainingJSONObject["name"];
    training.description = trainingJSONObject["description"];
    training.gender = trainingJSONObject["gender"].toString();
    training.trainingImage = trainingJSONObject["training_image"];
    if (trainingJSONObject['training_plans'].runtimeType == String) {
      training.trainingPlans =
          List.from(jsonDecode(trainingJSONObject['training_plans']))
              .map((element) =>
                  TrainingPlan.formJson(trainingPlanJSONObject: element))
              .toList();
    } else {
      training.trainingPlans = List.from(trainingJSONObject['training_plans'])
          .map((element) =>
              TrainingPlan.formJson(trainingPlanJSONObject: element))
          .toList();
    }

   if(AppDatabase.favouriteTrainingStream.value.where((element) => element.id == training.id).isNotEmpty)
      {
        training.favourite = true;
      }
    return training;

  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> useMap = <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'gender': gender,
      'training_image' : trainingImage,
      'training_plans': jsonEncode(trainingPlans.map((e) => e.toMap()).toList())
    };
    return useMap;
  }
}
