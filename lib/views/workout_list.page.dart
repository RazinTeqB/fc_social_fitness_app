import 'package:auto_size_text/auto_size_text.dart';
import 'package:fc_social_fitness/utils/flutter_flow_theme.util.dart';
import 'package:fc_social_fitness/views/widgets/fitness_loading.widget.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../constants/app_routes.dart';
import '../utils/internationalization.util.dart';
import '../viewmodels/workout_plan.viewmodel.dart';

class WorkoutPage extends StatefulWidget {
  @override
  _WorkoutPageState createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<WorkoutPlanViewModel>.reactive(
        viewModelBuilder: () => WorkoutPlanViewModel(context),
        onViewModelReady: (vm) => vm.initialise(),
        builder: (context, vm, child) {
          return vm.isBusy
              ? const FitnessLoading()
              : Scaffold(
                  backgroundColor:
                      FlutterFlowTheme.of(context).primaryBackground,
                  body: NestedScrollView(
                    headerSliverBuilder: (context, value) {
                      return [
                        SliverAppBar(
                          centerTitle: true,
                          leading: IconButton(
                            icon: Icon(Icons.arrow_back_ios_new,
                                size: 25,
                                color: FlutterFlowTheme.of(context).primaryText),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          title: AutoSizeText(
                            FFLocalizations.of(context).getText('allenamentiPersonalizzati'),
                            maxLines: 1,
                            style: FlutterFlowTheme.of(context).bodyText1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          backgroundColor:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          expandedHeight: 60,
                        ),
                      ];
                    },
                    body: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: vm.workoutPlans.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, i) {
                          return GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, AppRoutes.workoutListDetailRoute,
                                    arguments: [
                                      vm.workoutPlans[i].exercises,
                                      vm.workoutPlans[i].name,
                                    ]);
                              },
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 15, right: 15, left: 15),
                                  child: Container(
                                      padding: const EdgeInsets.all(15),
                                      height: 90,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                AutoSizeText(
                                                    "${vm.workoutPlans[i].name}",
                                                    maxLines: 1,
                                                    style: FlutterFlowTheme.of(context).title3),
                                                Text("${vm.workoutPlans[i].exercises.length} esercizi",
                                                    style: FlutterFlowTheme.of(context).bodyText1)
                                              ],
                                            ),
                                             const Icon(Icons.arrow_forward_ios_rounded)
                                          ]))));
                        }),
                  ),
                );
        });
  }
}