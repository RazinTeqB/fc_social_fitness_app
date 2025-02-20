import 'lesson.model.dart';

class Course {
  String? name;
  String? courseImage;
  String? color;
  List<Lesson> lessons = [];

  Course({this.name,this.courseImage});

  factory Course.formJson({
    required dynamic courseJSONObject,
  }) {
    final course = Course();
    course.name = courseJSONObject["name"];
    course.courseImage = courseJSONObject["course_image"];
    course.color = courseJSONObject["color"];
    course.lessons = List.from(courseJSONObject['lessons']).map((element) => Lesson.formJson(lessonJSONObject: element)).toList();

    return course;
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> useMap = <String, dynamic>{
      'name': name,
      'course_image': courseImage,
    };
    return useMap;
  }
}
