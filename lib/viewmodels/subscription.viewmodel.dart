import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/api_response.dart';
import '../models/subscription.model.dart';
import '../repositories/auth.repository.dart';
import '../repositories/payment.repository.dart';
import '../repositories/subscription.repository.dart';
import 'base.viewmodel.dart';

class SubscriptionViewModel extends CustomBaseViewModel {
  final AuthRepository _authRepository = AuthRepository();
  final SubscriptionRepository subscriptionRepository =
      SubscriptionRepository();
  final PaymentRepository paymentRepository = PaymentRepository();
  List<Subscription> subscriptions = [];
  List<Subscription> userSubscriptions = [];

  SubscriptionViewModel(BuildContext context) {
    viewContext = context;
  }

  @override
  Future initialise() async {
    setBusy(true);
    super.initialise();
    subscriptions = await getSubscriptions();
    userSubscriptions = await getUserSubscriptions();
    setBusy(false);
  }

  Future<List<Subscription>> getUserSubscriptions() async {
    List<Subscription> subscriptionsArray = [];
    ApiResponse response = await subscriptionRepository.getUserSubscriptions(viewContext);

    if (response.allGood) {
      final subscriptionsJSONObject = (response.body["subscriptions"] as List);
      subscriptionsJSONObject.forEach((subscriptionJSONObject) {
        subscriptionsArray.add(Subscription.formJson(subscriptionJSONObject: subscriptionJSONObject));  // Usa il parametro nominato qui
      });
    }
    return subscriptionsArray;
  }

  Future<List<Subscription>> getSubscriptions() async {
    List<Subscription> subscriptionsArray = [];
    ApiResponse response =
        await subscriptionRepository.getSubscriptions(viewContext);

    if (response.allGood) {
      final subscriptionsJSONObject = (response.body["subscriptions"] as List);
      subscriptionsJSONObject.asMap().forEach(
        (index, subscriptionJSONObject) {
          subscriptionsArray.add(Subscription.formJson(
              subscriptionJSONObject: subscriptionJSONObject));
        },
      );
    }
    return subscriptionsArray;
  }
}
