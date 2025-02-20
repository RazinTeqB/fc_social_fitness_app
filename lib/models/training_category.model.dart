import 'package:fc_social_fitness/models/training.model.dart';

class TrainingCategory {
  String? name;
  String? id;
  List<Training> trainings = [];
  TrainingCategory();

  factory TrainingCategory.formJson({
    required dynamic trainingCategoryJSONObject,
  }) {
    final trainingCategory = TrainingCategory();
    trainingCategory.id = trainingCategoryJSONObject["id"].toString();
    trainingCategory.name = trainingCategoryJSONObject["name"];
    trainingCategory.trainings = List.from(trainingCategoryJSONObject['trainings']).map((element) => Training.formJson(trainingJSONObject: element)).toList();
    return trainingCategory;
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> useMap = <String, dynamic>{
      'id': id,
      'name': name,
    };
    return useMap;
  }
}
