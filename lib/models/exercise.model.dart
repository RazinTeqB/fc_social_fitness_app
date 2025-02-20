/*
class Exercise {
  String? id;
  String? name;
  String? description;
  String? sets;
  String? reps;
  String? recover;
  String? video;
  String? exerciseImage;


  Exercise({this.name, this.sets, this.reps, this.recover, this.video});

  factory Exercise.formJson({
    required dynamic exerciseJSONObject,
  }) {
    final exercise = Exercise();
    exercise.id = exerciseJSONObject["id"].toString();
    exercise.name = exerciseJSONObject["name"];
    exercise.sets = exerciseJSONObject["pivot"]["sets"].toString();
    exercise.reps = exerciseJSONObject["pivot"]["reps"].toString();
    exercise.description = exerciseJSONObject["description"];
    exercise.recover = exerciseJSONObject["pivot"]["recover"].toString();
    exercise.video = exerciseJSONObject["video"];
    exercise.exerciseImage = exerciseJSONObject["exercise_image"];
    return exercise;
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> useMap = <String, dynamic>{
      'id': id,
      'name': name,
      'pivot': {'sets': sets, 'reps': reps , 'recover': recover},
      'description': description,
      'video': video,
      'exercise_image' : exerciseImage
    };
    return useMap;
  }
}*/
class Exercise {
  String? id;
  String? name;
  String? description;
  String? sets;
  String? reps;
  String? recover;
  String? video;
  String? exerciseImage;

  Exercise({this.name, this.sets, this.reps, this.recover, this.video});

  factory Exercise.fromJson({
    required dynamic exerciseJSONObject,
  }) {
    final exercise = Exercise();
    exercise.id = exerciseJSONObject["id"].toString();
    exercise.name = exerciseJSONObject["name"];
    exercise.sets = exerciseJSONObject["pivot"]["sets"].toString();
    exercise.reps = exerciseJSONObject["pivot"]["reps"].toString();
    exercise.description = exerciseJSONObject["description"];
    exercise.recover = exerciseJSONObject["pivot"]["recover"].toString();
    exercise.video = exerciseJSONObject["video"];
    exercise.exerciseImage = exerciseJSONObject["exercise_image"];
    return exercise;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'pivot': {'sets': sets, 'reps': reps, 'recover': recover},
      'description': description,
      'video': video,
      'exercise_image': exerciseImage
    };
  }
}