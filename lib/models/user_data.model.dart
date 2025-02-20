class UserData {
  String? id;
  String? name;
  String? bio;
  DateTime? dateBorn;
  String? profilePic;
  String? height;
  String? weight;
  String? gender;
  int? userID;

  UserData(
      {this.id,
      this.name,
      this.bio,
      this.dateBorn,
      this.profilePic,
      this.height,
      this.weight,
        this.gender,
      this.userID});

  factory UserData.formJson({
    required dynamic userJSONObject,
  }) {
    final userData = UserData();
    userData.id = userJSONObject["id"].toString();
    userData.name = userJSONObject["name"];
    userData.gender = userJSONObject["gender"];
    userData.bio = userJSONObject["bio"];

    try {
      userData.dateBorn = DateTime.parse(userJSONObject["date_born"]);
    } catch (e) {
      userData.dateBorn =
          DateTime.fromMillisecondsSinceEpoch(userJSONObject["date_born"]);
    }
    userData.profilePic = userJSONObject["image_path"];
    userData.height = userJSONObject["height"].toString();
    userData.weight = userJSONObject["weight"].toString();
    userData.userID = userJSONObject["user_id"];

    return userData;
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> useMap = <String, dynamic>{
      'id': id,
      'name': name,
      'bio': bio,
      'date_born': dateBorn?.millisecondsSinceEpoch,
      'image_path': profilePic,
      'height': height,
      'weight': weight,
      'gender': gender,
      'user_id': userID
    };
    return useMap;
  }
}
