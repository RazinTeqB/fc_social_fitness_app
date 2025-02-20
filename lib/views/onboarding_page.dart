import 'package:fc_social_fitness/constants/text_constants.dart';
import 'package:fc_social_fitness/utils/flutter_flow_theme.util.dart';
import 'package:fc_social_fitness/views/widgets/onbordingpage.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:stacked/stacked.dart';
import '../constants/app_routes.dart';
import '../viewmodels/base.viewmodel.dart';
import '../viewmodels/onboarding.viewmodel.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    int currentPage = 0;
    int totalPage = 2;
    return ViewModelBuilder<OnBoardingViewModel>.reactive(
        viewModelBuilder: () => OnBoardingViewModel(context),
        onViewModelReady: (model) => model.initialise(),
        builder: (context, vm, child) {
          return Scaffold(
              backgroundColor: Colors.white,
              body: PageView(
                physics: NeverScrollableScrollPhysics(),
                controller: vm.pageController,
                children: [
                  OnboardingPageWidget(
                    imagePath:
                        "assets/images/onboarding/onboardingcomplete1.png",
                    title: TextConstants.onboarding1Title,
                    body: TextConstants.onboarding1Description,
                    onNext: () {
                      vm.updateCurrentPageIndex(1);
                    },
                    pageIndex: 0,
                  ),
                  OnboardingPageWidget(
                    imagePath:
                        "assets/images/onboarding/onboardingcomplete2.png",
                    title: TextConstants.onboarding2Title,
                    body: TextConstants.onboarding2Description,
                    onNext: () {
                      vm.updateCurrentPageIndex(2);
                    },
                    pageIndex: 1,
                  ),
                  OnboardingPageWidget(
                    imagePath:
                        "assets/images/onboarding/onboardingcomplete3.png",
                    title: TextConstants.onboarding3Title,
                    body: TextConstants.onboarding3Description,
                    onNext: () {
                      Navigator.pushNamed(context, AppRoutes.loginRoute);
                    },
                    pageIndex: 2,
                  ),
                ],
              ));
        });
  }
}
