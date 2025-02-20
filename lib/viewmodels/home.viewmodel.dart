import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants/app_routes.dart';
import 'base.viewmodel.dart';

class HomeViewModel extends CustomBaseViewModel {
  HomeViewModel(BuildContext context) {
    viewContext = context;
  }

  @override
  Future initialise() async {
    setBusy(true);
    await super.initialise();
    await Future.delayed(const Duration(seconds: 1));
    if (!checkSubscription()) {
      Navigator.pushNamed(viewContext, AppRoutes.subscriptionRoute,arguments: true);
    }
    setBusy(false);
  }
}
