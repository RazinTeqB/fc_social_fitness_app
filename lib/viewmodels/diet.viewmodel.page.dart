import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'base.viewmodel.dart';

class DietViewModel extends CustomBaseViewModel {
  DietViewModel(BuildContext context) {
    viewContext = context;
  }

  @override
  Future initialise() async {
    setBusy(true);
    await super.initialise();
    setBusy(false);
  }
}

