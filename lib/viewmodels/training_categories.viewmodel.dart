import 'package:fc_social_fitness/models/api_response.dart';
import 'package:fc_social_fitness/repositories/course.repository.dart';
import 'package:fc_social_fitness/utils/shared_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/training.model.dart';
import '../models/training_category.model.dart';
import 'base.viewmodel.dart';

class TrainingCategoriesViewModel extends CustomBaseViewModel {
  final TrainingRepository trainingRepository = TrainingRepository();
  List<TrainingCategory> trainingCategories = [];
  List<Training> trainingsToShow = [];
  Map<String,String> genderItems = {"0":"Uomo","1":"Donna","2":"Non specificato"};
  String selectedGender = "2";
  int selectedTab = 0;
  TrainingCategoriesViewModel(BuildContext context, int page) {
    viewContext = context;
    page = page;
  }

  @override
  Future initialise() async {
    setBusy(true);
    await super.initialise();
    selectedGender = SharedManager.getString("gender", defaultValue: "2");
    trainingCategories = await getTrainingCategories();
    if(selectedGender == "2")
      {
        trainingsToShow = trainingCategories[selectedTab].trainings;
      }else{
        trainingsToShow = trainingCategories[selectedTab].trainings.where((element) => element.gender == selectedGender).toList();
    }
    setBusy(false);
  }

  void changeGenderTab() async
  {
    trainingsToShow = [];
    if(selectedGender == "2")
    {
      trainingsToShow = trainingCategories[selectedTab].trainings;
    }else{
      trainingsToShow = trainingCategories[selectedTab].trainings.where((element) => element.gender == selectedGender).toList();
    }
    await SharedManager.setString("gender", selectedGender);
  }

  Future<List<TrainingCategory>> getTrainingCategories() async {
    late List<TrainingCategory> trainingCategoriesArray = [];
    ApiResponse response =
        await trainingRepository.getTrainingCategories(viewContext);
    if (response.allGood) {
      final trainingCategoriesJSONObject =
          (response.body["training_categories"] as List);
      trainingCategoriesJSONObject.asMap().forEach(
        (index, trainingCategoryJSONObject) {
          trainingCategoriesArray.add(TrainingCategory.formJson(
              trainingCategoryJSONObject: trainingCategoryJSONObject));
        },
      );
    }
    return trainingCategoriesArray;
  }

}
