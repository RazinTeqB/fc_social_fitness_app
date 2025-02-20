import 'package:fc_social_fitness/utils/flutter_flow_theme.util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'package:video_player/video_player.dart';
import '../models/workout_plan.model.dart';
import '../utils/internationalization.util.dart';
import '../viewmodels/workout_detail.viewmodel.dart';
import 'package:im_stepper/stepper.dart';

class WorkoutDetailPage extends StatefulWidget {
  final WorkoutPlan workoutPlan;

  const WorkoutDetailPage({Key? key, required this.workoutPlan})
      : super(key: key);

  @override
  _WorkoutDetailPageState createState() => _WorkoutDetailPageState();
}

class _WorkoutDetailPageState extends State<WorkoutDetailPage> {
  List<VideoPlayerController> videoControllerList = [];
  int currentPageIndex = 0;
  final PageController pageControllerExercises = PageController();

  @override
  void initState() {
    super.initState();
    currentPageIndex = 0;
    /*BetterPlayerConfiguration betterPlayerConfiguration = BetterPlayerConfiguration(
      aspectRatio: 16 / 9,
      fit: BoxFit.contain,
      autoPlay: true,
      looping: true,
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.portraitDown,
        DeviceOrientation.portraitUp
      ],
    );*/
    widget.workoutPlan.exercises.forEach((element) {
      /*BetterPlayerDataSource source = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        element.video!,
      );
      BetterPlayerController _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
      _betterPlayerController.setupDataSource(source);*/
      VideoPlayerController controller =
          VideoPlayerController.network(element.video!)
            ..initialize().then((_) {
              // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
              setState(() {});
            });
      videoControllerList.add(controller);
    });
  }

  @override
  void dispose() {
    videoControllerList.forEach((element) {
      element.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<WorkoutPlanDetailViewModel>.reactive(
        viewModelBuilder: () =>
            WorkoutPlanDetailViewModel(context, widget.workoutPlan.exercises),
        onViewModelReady: (vm) => vm.initialise(),
        builder: (context, vm, child) {
          return Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    videoControllerList[currentPageIndex].value.isPlaying
                        ? videoControllerList[currentPageIndex].pause()
                        : videoControllerList[currentPageIndex].play();
                  });
                },
                child: Icon(
                  videoControllerList[currentPageIndex].value.isPlaying
                      ? Icons.pause
                      : Icons.play_arrow,
                ),
              ),
              appBar: AppBar(
                  title: Text(
                    FFLocalizations.of(context).getText('scheda'),
                    style: FlutterFlowTheme.of(context).title1,
                  ),
                  backgroundColor:
                      FlutterFlowTheme.of(context).secondaryBackground,
                  elevation: 0,
                  leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: FlutterFlowTheme.of(context).black,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  iconTheme: IconThemeData(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  )),
              body: PageView.builder(
                onPageChanged: (int index) {
                  setState(() {
                    currentPageIndex = index;
                    videoControllerList.forEach((element) {
                      element.pause();
                    });
                  });
                },
                controller: pageControllerExercises,
                itemCount: widget.workoutPlan.exercises.length,
                itemBuilder: (BuildContext context, int index) {
                  return currentPageIndex == index
                      ? Stack(
                          children: <Widget>[
                            Positioned(
                              child: ListView(
                                padding: const EdgeInsets.only(
                                  bottom: 300,
                                ),
                                children: [
                                  Container(
                                    height: 295,
                                    child: AspectRatio(
                                      aspectRatio: videoControllerList[index]
                                          .value
                                          .aspectRatio,
                                      child: Stack(
                                        alignment: Alignment.bottomCenter,
                                        children: <Widget>[
                                          VideoPlayer(
                                              videoControllerList[index]),
                                          _ControlsOverlay(
                                              controller:
                                                  videoControllerList[index]),
                                          VideoProgressIndicator(
                                              videoControllerList[index],
                                              allowScrubbing: true),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.fromLTRB(15, 25, 15, 10),
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              FlutterFlowTheme.of(context).grey,
                                          offset: const Offset(0, 1.0),
                                          spreadRadius: 2.0,
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            "${widget.workoutPlan.exercises[index].name}",
                                            style: FlutterFlowTheme.of(context)
                                                .title1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  //product description
                                  Container(
                                    padding: EdgeInsets.all(15),
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    child: Expanded(
                                      child: Text("AAAAAAAAA"),
                                    ),
                                  ),
                                  widget.workoutPlan.exercises.length < 2
                                      ? Container()
                                      : Container(
                                          height: 350,
                                          alignment: Alignment.bottomCenter,
                                          child: DotStepper(
                                            fixedDotDecoration:
                                                FixedDotDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryColor),
                                            direction: Axis.horizontal,
                                            indicator: Indicator.jump,
                                            tappingEnabled: true,
                                            dotCount: widget
                                                .workoutPlan.exercises.length,
                                            dotRadius: 9,
                                            activeStep: currentPageIndex,
                                            spacing: 10,
                                            shape: Shape.squircle,
                                            onDotTapped:
                                                _updateCurrentPageIndex,
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Container();
                },
              ));
        });
  }

  void _updateCurrentPageIndex(int pageIndex) {
    setState(() {
      currentPageIndex = pageIndex;
    });
  }
}

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({required this.controller});

  static const List<Duration> _exampleCaptionOffsets = <Duration>[
    Duration(seconds: -10),
    Duration(seconds: -3),
    Duration(seconds: -1, milliseconds: -500),
    Duration(milliseconds: -250),
    Duration.zero,
    Duration(milliseconds: 250),
    Duration(seconds: 1, milliseconds: 500),
    Duration(seconds: 3),
    Duration(seconds: 10),
  ];
  static const List<double> _examplePlaybackRates = <double>[
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
    3.0,
    5.0,
    10.0,
  ];

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 50),
          reverseDuration: const Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? const SizedBox.shrink()
              : Container(
                  color: Colors.black26,
                  child: const Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 100.0,
                      semanticLabel: 'Play',
                    ),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
        Align(
          alignment: Alignment.topLeft,
          child: PopupMenuButton<Duration>(
            initialValue: controller.value.captionOffset,
            tooltip: 'Caption Offset',
            onSelected: (Duration delay) {
              controller.setCaptionOffset(delay);
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuItem<Duration>>[
                for (final Duration offsetDuration in _exampleCaptionOffsets)
                  PopupMenuItem<Duration>(
                    value: offsetDuration,
                    child: Text('${offsetDuration.inMilliseconds}ms'),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
// Using less vertical padding as the text is also longer
// horizontally, so it feels like it would need more spacing
// horizontally (matching the aspect ratio of the video).
                vertical: 12,
                horizontal: 16,
              ),
              child: Text('${controller.value.captionOffset.inMilliseconds}ms'),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: PopupMenuButton<double>(
            initialValue: controller.value.playbackSpeed,
            tooltip: 'Playback speed',
            onSelected: (double speed) {
              controller.setPlaybackSpeed(speed);
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuItem<double>>[
                for (final double speed in _examplePlaybackRates)
                  PopupMenuItem<double>(
                    value: speed,
                    child: Text('${speed}x'),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
// Using less vertical padding as the text is also longer
// horizontally, so it feels like it would need more spacing
// horizontally (matching the aspect ratio of the video).
                vertical: 12,
                horizontal: 16,
              ),
              child: Text('${controller.value.playbackSpeed}x'),
            ),
          ),
        ),
      ],
    );
  }
}
