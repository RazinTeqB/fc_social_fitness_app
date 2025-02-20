import 'package:fc_social_fitness/utils/app_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/api_response.dart';
import '../models/course.model.dart';
import '../models/training.model.dart';
import '../models/virtualclass.model.dart';
import '../models/workout_plan.model.dart';
import '../repositories/course.repository.dart';
import '../repositories/virtual_class.repository.dart';
import '../repositories/workout_plan.repository.dart';
import 'base.viewmodel.dart';

class DashboardViewModel extends CustomBaseViewModel {

  final WorkoutPlanRepository workoutPlanRepository = WorkoutPlanRepository();
  final VirtualClassRepository _virtualClassRepository =
  VirtualClassRepository();

  List<WorkoutPlan> workoutPlans = [];



  DashboardViewModel(BuildContext context) {
    viewContext = context;
  }

  @override
  Future initialise() async {
    setBusy(true);
    AppDatabase.getFavouriteTrainings();
    await super.initialise();
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
