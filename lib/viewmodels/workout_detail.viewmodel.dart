import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/exercise.model.dart';
import '../repositories/workout_plan_detail.repository.dart';
import 'base.viewmodel.dart';

class WorkoutPlanDetailViewModel extends CustomBaseViewModel {
  final WorkoutPlanDetailRepository workoutPlanDetailRepository = WorkoutPlanDetailRepository();
  List<Exercise> exercises = [];

  WorkoutPlanDetailViewModel(BuildContext context, List<Exercise> exercisesList) {
    viewContext = context;
    exercises = exercisesList
      ..sort((a, b) => int.parse(a.id!).compareTo(int.parse(b.id!)));
  }

  @override
  Future initialise() async {
    setBusy(true);
    await super.initialise();
    setBusy(false);
  }

}
