import 'package:fc_social_fitness/constants/app_routes.dart';
import 'package:fc_social_fitness/models/exercise.model.dart';
import 'package:fc_social_fitness/models/workout_plan.model.dart';
import 'package:fc_social_fitness/social/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:fc_social_fitness/viewmodels/change_password.viewmodel.dart';
import 'package:fc_social_fitness/views/additional_subscription.page.dart';
import 'package:fc_social_fitness/views/change_password.page.dart';
import 'package:fc_social_fitness/views/edit_personal_info.page.dart';
import 'package:fc_social_fitness/views/entry.page.dart';
import 'package:fc_social_fitness/views/exercise_details.page.dart';
import 'package:fc_social_fitness/views/login.page.dart';
import 'package:fc_social_fitness/views/settings.page.dart';
import 'package:fc_social_fitness/views/sign_up_number.page.dart';
import 'package:fc_social_fitness/views/sign_up_step1.page.dart';
import 'package:fc_social_fitness/views/subscription.page.dart';
import 'package:fc_social_fitness/views/support.page.dart';
import 'package:fc_social_fitness/views/training_form_submitted.page.dart';
import 'package:fc_social_fitness/views/workout_detail.page.dart';
import 'package:fc_social_fitness/views/workout_list.page.dart';
import 'package:flutter/material.dart';
import '../models/training_plan.model.dart';
import '../social/presentation/pages/profile/edit_profile_page.dart';
import '../viewmodels/signup.viewmodel.dart';
import '../views/change_email.page.dart';
import '../views/change_password_otp.page.dart';
import '../views/diet.page.dart';
import '../views/diet_form_submitted.page.dart';
import '../views/my_subscriptions_page.dart';
import '../views/personal_training_survey.dart';
import '../views/workout_list_details_page.dart';
import '../views/home.page.dart';
import '../views/onboarding_page.dart';
import '../views/sign_up_step2.page.dart';
import '../views/training_details.page.dart';

Route<dynamic>? generateRoute(RouteSettings settings) {
  final List<String> pathElements = settings.name!.split('/');
  if (pathElements[0] != '' || pathElements.length == 1) {
    // return null;
  }
  switch (settings.name) {
    case AppRoutes.onBoarding:
      return MaterialPageRoute(builder: (context) => OnboardingPage());
    case AppRoutes.signupStepOneRoute:
      return MaterialPageRoute(
          builder: (context) =>
              SignUpStepOne(vm: settings.arguments as SignupViewModel));
    case AppRoutes.signupStepTwoRoute:
      return MaterialPageRoute(
          builder: (context) =>
              SignUpStepTwo(vm: settings.arguments as SignupViewModel));
    case AppRoutes.homeRoute:
      return MaterialPageRoute(builder: (context) => HomePage(activeTab: settings.arguments as int,));
    case AppRoutes.entryRoute:
      return MaterialPageRoute(builder: (context) => EntryPage(startPage: HomePage(activeTab:(settings.arguments as List)[0] as int,activeTabSocial:(settings.arguments as List)[1],)));
    case AppRoutes.settingsRoute:
      return MaterialPageRoute(builder: (context) => SettingsPage());
    case AppRoutes.editPersonalInfoRoute:
      return MaterialPageRoute(builder: (context) => EditPersonalInfo());
    case AppRoutes.exerciseDetails:
      return MaterialPageRoute(
          builder: (context) => ExerciseDetailsPage(
              exercises: (settings.arguments as List)[0] as List<Exercise>,
              index: (settings.arguments as List)[1] as int,
              exerciseName: (settings.arguments as List)[2] as String)
      );

    case AppRoutes.workoutListDetailRoute:
      return MaterialPageRoute(
          builder: (context) => WorkoutListDetailsPage(
              exercises: (settings.arguments as List)[0] as List<Exercise>,
              workoutPlanName: (settings.arguments as List)[1] as String)
      );


    case AppRoutes.signupNumberRoute:
      return MaterialPageRoute(builder: (context) => SignUpNumber());
    case AppRoutes.dietRoute:
      return MaterialPageRoute(builder: (context) => DietPage());
    case AppRoutes.loginRoute:
      return MaterialPageRoute(builder: (context) => SignInPage());
    case AppRoutes.subscriptionRoute:
      return MaterialPageRoute(builder: (context) => SubscriptionPage(dueSubscription: settings.arguments as bool,));
    case AppRoutes.additionalSubscriptionRoute:
      return MaterialPageRoute(
        builder: (context) => AdditionalSubscriptionPage(dueSubscription: (settings.arguments as bool?) ?? false,),);
    case AppRoutes.changePassword:
      return MaterialPageRoute(builder: (context) => ChangePasswordPage(vm: settings.arguments as ChangePasswordViewModel));
    case AppRoutes.changeEmail:
      return MaterialPageRoute(builder: (context) => ChangeEmailPage(vm: settings.arguments as ChangePasswordViewModel));
    case AppRoutes.changeCredentialOtp:
      return MaterialPageRoute(builder: (context) => ChangeCredentialOtp(page:settings.arguments as int));
    case AppRoutes.editprofileRoute:
      return MaterialPageRoute(builder: (context) => EditProfilePage(settings.arguments as UserPersonalInfo));
    case AppRoutes.workoutPlanRoute:
      return MaterialPageRoute(builder: (context) => WorkoutPage());
    case AppRoutes.surveyPersonalTrainingRoute:
      return MaterialPageRoute(builder: (context) => PersonalTrainingPage());
    case AppRoutes.trainingFormSubmittedRoute:
      return MaterialPageRoute(builder: (context) => TrainingFormSubmittedPage());
    case AppRoutes.dietFormSubmittedRoute:
      return MaterialPageRoute(builder: (context) => DietFormSubmittedPage());
    case AppRoutes.helpRoute:
      return MaterialPageRoute(builder: (context) => SupportPage());
    case AppRoutes.mySubscriptionRoute:
      return MaterialPageRoute(builder: (context) => MySubscriptionsPage());
    case AppRoutes.trainingDetails:
      return MaterialPageRoute(
          builder: (context) => TrainingDetailsPage(
              trainingPlans: (settings.arguments as List)[0] as List<TrainingPlan>, trainingName: (settings.arguments as List)[1] as String));
    case AppRoutes.workoutDetailRoute:
      return MaterialPageRoute(
          builder: (context) => WorkoutDetailPage(
                workoutPlan: settings.arguments as WorkoutPlan,
              ));



    default:
      return MaterialPageRoute(builder: (context) => const HomePage(activeTab: 0,));
  }
}
