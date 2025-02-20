class Lesson {
  String? id;
  String? name;
  String? video;
  String? thumb;
  int? duration;

  Lesson({this.name, this.video, this.thumb, this.duration});

  factory Lesson.formJson({
    required dynamic lessonJSONObject,
  }) {
    final lesson = Lesson();
    lesson.id = lessonJSONObject["id"].toString();
    lesson.name = lessonJSONObject["name"];
    lesson.video = lessonJSONObject["video"];
    lesson.thumb = lessonJSONObject["thumb"];
    lesson.duration = lessonJSONObject["duration"];

    return lesson;
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> useMap = <String, dynamic>{
      'id': id,
      'name': name,
      'video': video,
      'thumb': thumb,
      'duration': duration,
    };
    return useMap;
  }
}
