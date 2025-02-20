import 'package:auto_size_text/auto_size_text.dart';
import 'package:fc_social_fitness/models/exercise.model.dart';
import 'package:fc_social_fitness/utils/flutter_flow_theme.util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../constants/app_routes.dart';
import '../utils/internationalization.util.dart';

class WorkoutListDetailsPage extends StatefulWidget {
  const WorkoutListDetailsPage({
    Key? key,
    required this.exercises,
    required this.workoutPlanName,
  }) : super(key: key);

  final List<Exercise> exercises;
  final String workoutPlanName;

  @override
  WorkoutListDetailsPageState createState() => WorkoutListDetailsPageState();
}

class WorkoutListDetailsPageState extends State<WorkoutListDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: NestedScrollView(
        headerSliverBuilder: (context, value) {
          return [
            SliverAppBar(
              centerTitle: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back,
                    color: FlutterFlowTheme.of(context).black),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text(
                "${widget.workoutPlanName}",
                style: FlutterFlowTheme.of(context).title1,
              ),
              backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
              expandedHeight: 60,
            ),
          ];
        },
        body: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: widget.exercises.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, i) {
              return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.exerciseDetails,
                        arguments: [
                          widget.exercises,
                          i,
                          widget.exercises[i].name,
                        ]);
                  },
                  child: Padding(
                      padding:
                          const EdgeInsets.only(top: 15, right: 15, left: 15),
                      child: Container(
                        height: 90,
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground),
                        child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AutoSizeText(

                                    "${widget.exercises[i].name}",
                                    maxFontSize: 16,
                                    maxLines: 1,
                                    style: FlutterFlowTheme.of(context).title1),
                                Row(children: [
                                  Row(
                                    children: [
                                      const FaIcon(FontAwesomeIcons.dumbbell,
                                          size: 15),
                                      SizedBox(width: 5),
                                      Text(
                                          "${widget.exercises[i].sets} x ${widget.exercises[i].reps}",
                                          style: FlutterFlowTheme.of(context)
                                              .bodyText1)
                                    ],
                                  ),
                                  SizedBox(width: 30),
                                  Row(
                                    children: [
                                      const FaIcon(FontAwesomeIcons.clock,
                                          size: 15),
                                      SizedBox(width: 5),
                                      Text("${widget.exercises[i].recover}",
                                          style: FlutterFlowTheme.of(context)
                                              .bodyText1)
                                    ],
                                  )
                                ])
                              ]),
                          Icon(Icons.arrow_forward_ios_rounded)
                        ]),
                      )));
            }),
      ),
    );
  }
}
