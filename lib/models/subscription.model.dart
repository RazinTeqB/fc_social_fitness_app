import 'lesson.model.dart';

class Subscription {
  int? id;
  String? title;
  String? description;
  double? price;
  DateTime? dueSubscriptionDate;
  Subscription({this.id,this.title, this.price, this.description, this.dueSubscriptionDate});

  factory Subscription.formJson({
    required dynamic subscriptionJSONObject,
  }) {
    final subscription = Subscription();
    print(subscriptionJSONObject);
    subscription.id = subscriptionJSONObject["id"];
    subscription.title = subscriptionJSONObject["title"];
    subscription.description = subscriptionJSONObject["description"];
    subscription.price = double.parse(subscriptionJSONObject["price"].toString());
    if(subscriptionJSONObject["pivot"]!=null)
      {
        try {
          subscription.dueSubscriptionDate = DateTime.parse(subscriptionJSONObject["pivot"]["due_subscription_date"]);
        } catch (e) {
          subscription.dueSubscriptionDate = DateTime.fromMillisecondsSinceEpoch(
              subscriptionJSONObject["pivot"]["due_subscription_date"]);
        }
      }

    return subscription;
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> useMap = <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'pivot':{
        'due_subscription_date':dueSubscriptionDate?.millisecondsSinceEpoch
      }
    };
    return useMap;
  }
}
