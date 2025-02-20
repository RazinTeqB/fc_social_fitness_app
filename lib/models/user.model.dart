import 'package:fc_social_fitness/models/subscription.model.dart';
import 'package:fc_social_fitness/models/user_data.model.dart';

class User {
  String? id;
  String? username;
  String? email;
  String? token;
  String? phone;
  List<Subscription>? subscriptions = [];
  UserData? userData;
  User({this.id, this.username, this.email, this.token, this.subscriptions});

  factory User.formJson({
    required dynamic userJSONObject,
  }) {
    print(userJSONObject);
    final user = User();
    user.id = userJSONObject["id"].toString();
    user.username = userJSONObject["username"];
    user.email = userJSONObject["email"];
    user.phone = userJSONObject["phone"];
    user.token = userJSONObject["token"];
    user.subscriptions = List.from(userJSONObject['subscriptions']).map((element) => Subscription.formJson(subscriptionJSONObject: element)).toList();
    user.userData = userJSONObject["user_data"] != null
        ? userJSONObject["user_data"] == "{}"
            ? null
            : UserData.formJson(userJSONObject: userJSONObject["user_data"])
        : null;
    return user;
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> useMap = <String, dynamic>{
      'id': id,
      'username': username,
      'email': email,
      'phone': phone,
      'token': token,
      'subscriptions': subscriptions?.map((sub) => sub.toMap()).toList(),
      'user_data': userData == null ? "{}" : userData!.toMap()
    };
    return useMap;
  }
}
