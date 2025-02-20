import 'package:fc_social_fitness/models/user.model.dart';
import 'package:fc_social_fitness/models/user_data.model.dart';

import 'exercise.model.dart';

class VirtualClass {
  String? id;
  String? name;
  String? password;
  int? tipology;
  User? user;
  int? userID;
  String? virtualClassID;
  DateTime? createdAt;
  VirtualClass({this.name,this.user,this.password,this.tipology,this.userID,this.virtualClassID});

  factory VirtualClass.formJson({
    required dynamic virtualClassJSONObject,
  }) {
    final virtualClass = VirtualClass();
    virtualClass.id = virtualClassJSONObject["id"].toString();
    virtualClass.name = virtualClassJSONObject["name"];
    virtualClass.tipology = virtualClassJSONObject["tipology"];
    virtualClass.userID = virtualClassJSONObject["user_id"];
    virtualClass.user = User.formJson(userJSONObject: virtualClassJSONObject["user"]);
    virtualClass.createdAt = DateTime.parse(virtualClassJSONObject["created_at"].toString());
    return virtualClass;
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> useMap = <String, dynamic>{
      'name': name,
      'password': password,
      'tipology': tipology,
      'userID': userID,
      'virtualClassID': virtualClassID,
      'createdAt': createdAt,
    };
    return useMap;
  }
}
