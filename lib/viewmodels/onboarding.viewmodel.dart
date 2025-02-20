import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'base.viewmodel.dart';

class OnBoardingViewModel extends CustomBaseViewModel {
  OnBoardingViewModel(BuildContext context) {
    viewContext = context;
  }

  @override
  Future initialise() async {
    setBusy(true);
    super.initialise();
    setBusy(false);
  }
}
