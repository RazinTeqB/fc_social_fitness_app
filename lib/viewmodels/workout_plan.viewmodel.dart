import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/api_response.dart';
import '../models/workout_plan.model.dart';
import '../repositories/workout_plan.repository.dart';
import 'base.viewmodel.dart';

class WorkoutPlanViewModel extends CustomBaseViewModel {
  final WorkoutPlanRepository workoutPlanRepository = WorkoutPlanRepository();
  List<WorkoutPlan> workoutPlans = [];

  WorkoutPlanViewModel(BuildContext context) {
    viewContext = context;
  }

  @override
  Future initialise() async {
    setBusy(true);
    await super.initialise();
    workoutPlans = await getWorkoutPlans();
    setBusy(false);
  }

  Future<List<WorkoutPlan>> getWorkoutPlans() async {
    late List<WorkoutPlan> workoutPlansArray = [];
    ApiResponse response =
        await workoutPlanRepository.getWorkoutPlans(viewContext);
    if (response.allGood) {
      final workoutPlansJSONObject = (response.body["workoutPlans"] as List);
      workoutPlansJSONObject.asMap().forEach(
        (index, workoutPlanJSONObject) {
          workoutPlansArray.add(WorkoutPlan.formJson(
              workoutPlanJSONObject: workoutPlanJSONObject));
        },
      );
    }
    return workoutPlansArray;
  }
}
