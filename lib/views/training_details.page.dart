import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../constants/app_routes.dart';
import '../models/exercise.model.dart';
import '../models/training_plan.model.dart';
import '../utils/flutter_flow_theme.util.dart';

class TrainingDetailsPage extends StatefulWidget {
  const TrainingDetailsPage({
    Key? key,
    required this.trainingPlans,
    required this.trainingName,
  }) : super(key: key);

  final List<TrainingPlan> trainingPlans;
  final String trainingName;

  @override
  _TrainingDetailsPageState createState() => _TrainingDetailsPageState();
}

class _TrainingDetailsPageState extends State<TrainingDetailsPage> {
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).trainingsBackground,
        body: DefaultTabController(
          length: widget.trainingPlans.length,
          child: NestedScrollView(
              headerSliverBuilder: (context, value) {
                return [
                  SliverAppBar(
                    leading: BackButton(
                        color: FlutterFlowTheme.of(context).primaryText),
                    elevation: 0,
                    centerTitle: true,
                    pinned: true,
                    title: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          widget.trainingName,
                          style: FlutterFlowTheme.of(context).title3,
                        )),
                    backgroundColor:
                    FlutterFlowTheme.of(context).secondaryBackground,
                    expandedHeight: 0,
                  ),
                  SliverPersistentHeader(
                    floating: true,
                    delegate: _SliverAppBarDelegate(
                        minHeight: 53,
                        maxHeight: 53,
                        child: Container(
                          color: FlutterFlowTheme.of(context)
                              .secondaryBackground,
                          child: TabBar(
                            indicatorColor:
                            FlutterFlowTheme.of(context).course20,
                            onTap: (index) {
                              setState(() {
                                pageIndex = index;
                              });
                            },
                            labelColor:
                            FlutterFlowTheme.of(context).primaryText,
                            unselectedLabelColor:
                            FlutterFlowTheme.of(context).secondaryText,
                            tabs: widget.trainingPlans
                                .map((trainingPlan) => Text(
                              trainingPlan.name!,
                              style: FlutterFlowTheme.of(context)
                                  .bodyText1,
                            ))
                                .toList(),
                          ),
                        )),
                  ),
                ];
              },
              body: Column(
                children: [
                  SizedBox(height: 15),
                  Expanded(
                      child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: widget
                              .trainingPlans[pageIndex].exercises.length,
                          itemBuilder: (context, i) {
                            return Container(
                                height: 90,
                                margin: const EdgeInsets.only(
                                    left: 15,
                                    right: 15,
                                    bottom: 15,
                                    top: 0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: InkWell(
                                    borderRadius: BorderRadius.circular(15),
                                    onTap: () {
                                      Navigator.pushNamed(context,
                                          AppRoutes.exerciseDetails,
                                          arguments: [
                                            widget.trainingPlans[pageIndex]
                                                .exercises,
                                            i,
                                            widget.trainingPlans[pageIndex]
                                                .exercises[i].name,
                                          ]);
                                    },
                                    child: Container(
                                        width: MediaQuery.of(context)
                                            .size
                                            .width,
                                        decoration: BoxDecoration(
                                          color:
                                          FlutterFlowTheme.of(context)
                                              .trainings,
                                          borderRadius:
                                          BorderRadius.circular(15),
                                        ),
                                        padding: const EdgeInsets.all(15),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            Expanded(child:Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Text(
                                                      "${widget.trainingPlans[pageIndex].exercises[i].name}",
                                                      maxLines: 1,
                                                      overflow: TextOverflow
                                                          .ellipsis,
                                                      style: FlutterFlowTheme
                                                          .of(context)
                                                          .bodyText1),
                                                  Row(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .center,
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .start,
                                                      children: [
                                                        FaIcon(
                                                            FontAwesomeIcons
                                                                .dumbbell,
                                                            size: 15),
                                                        SizedBox(width: 10),
                                                        Text(
                                                            "${widget.trainingPlans[pageIndex].exercises[i].sets} x ${widget.trainingPlans[pageIndex].exercises[i].reps}",
                                                            style: FlutterFlowTheme.of(
                                                                context)
                                                                .bodyText1),
                                                        SizedBox(width: 20),
                                                        FaIcon(
                                                            FontAwesomeIcons
                                                                .clock,
                                                            size: 15),
                                                        SizedBox(width: 10),
                                                        Text(
                                                            "${widget.trainingPlans[pageIndex].exercises[i].recover}",
                                                            style: FlutterFlowTheme.of(
                                                                context)
                                                                .bodyText1)
                                                      ])
                                                ])),
                                            SizedBox(width: 20),
                                            Icon(
                                                Icons
                                                    .arrow_forward_ios_rounded,
                                                size: 20)

                                            /*Container(
                                                  color: Colors.red,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      AutoSizeText(
                                                          "${widget.trainingPlans[pageIndex].exercises[i].name}",
                                                          maxLines: 2,
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyText1),

                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            alignment: Alignment
                                                                .center,

                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          10)),
                                                            ),
                                                            child: Row(
                                                              children: [
                                                                FaIcon(
                                                                    FontAwesomeIcons
                                                                        .dumbbell,
                                                                    size: 15),
                                                                Text(
                                                                    "${widget.trainingPlans[pageIndex].exercises[i].sets}x${widget.trainingPlans[pageIndex].exercises[i].reps}",
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyText1),
                                                              ],
                                                            ),
                                                          ),

                                                          Container(
                                                            alignment: Alignment
                                                                .center,
                                                            height: 30,
                                                            width: 100,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          10)),
                                                            ),
                                                            child: Row(
                                                              children: [
                                                                FaIcon(
                                                                    FontAwesomeIcons
                                                                        .clock,
                                                                    size: 15),
                                                                SizedBox(
                                                                    width: 10),
                                                                Text(
                                                                    "${widget.trainingPlans[pageIndex].exercises[i].recover}",
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyText1)
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                    flex: 1,
                                                    child: Icon(
                                                        Icons
                                                            .arrow_forward_ios_rounded,
                                                        size: 20))*/
                                          ],
                                        ))));
                          })),
                ],
              )),
        ));
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

class PageArguments {
  final List<Exercise> exercises;
  final int index;

  PageArguments({required this.exercises, required this.index});
}
