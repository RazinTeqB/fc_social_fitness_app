import 'package:chewie/chewie.dart';
import 'package:fc_social_fitness/utils/flutter_flow_theme.util.dart';
import 'package:fc_social_fitness/views/widgets/fitness_loading.widget.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../models/exercise.model.dart';

class ExerciseDetailsPage extends StatefulWidget {
  final List<Exercise> exercises;
  final int index;
  final String exerciseName;

  const ExerciseDetailsPage(
      {Key? key,
        required this.exercises,
        required this.index,
        required this.exerciseName})
      : super(key: key);

  @override
  _ExerciseDetailsPageState createState() => _ExerciseDetailsPageState();
}

class _ExerciseDetailsPageState extends State<ExerciseDetailsPage> {
  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;
  int currentPageIndex = 0;
  late PageController pageControllerExercises;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      videoPlayerController =
          VideoPlayerController.network(widget.exercises[widget.index].video!);
      await videoPlayerController?.initialize();
      chewieController = ChewieController(
          autoPlay: true,
          aspectRatio: videoPlayerController!.value.aspectRatio,
          placeholder: FitnessLoading(),
          videoPlayerController: videoPlayerController!);
      setState(() {
      });
    });
    currentPageIndex = widget.index;
    pageControllerExercises = PageController(initialPage: currentPageIndex);
    super.initState();
  }

  @override
  void dispose() {
    videoPlayerController?.dispose();
    chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).trainingsBackground,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(""),
        backgroundColor: FlutterFlowTheme.of(context).trainingsBackground,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new,
              size: 20, color: FlutterFlowTheme.of(context).primaryText),
          onPressed: () {
            videoPlayerController?.pause();
            Navigator.of(context).pop();
          },
        ),
        iconTheme: IconThemeData(
          color: FlutterFlowTheme.of(context).secondaryBackground,
        ),
      ),
      body: PageView.builder(
        onPageChanged: (int index) async {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            videoPlayerController?.dispose();
            chewieController?.dispose();
            setState(() {});
            videoPlayerController = VideoPlayerController.network(
                widget.exercises[index].video!);
            await videoPlayerController!.initialize();
            chewieController = ChewieController(
                autoPlay: true,
                aspectRatio: videoPlayerController!.value.aspectRatio,
                placeholder: const FitnessLoading(),
                videoPlayerController: videoPlayerController!);
            setState(() {});
          });
          setState(() {
            currentPageIndex = index;
          });
        },
        controller: pageControllerExercises,
        itemCount: widget.exercises.length,
        itemBuilder: (BuildContext context, int index) {
          return currentPageIndex == index
              ? SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  child: videoPlayerController != null
                      ? Chewie(controller: chewieController!)
                      : const FitnessLoading(),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: FlutterFlowTheme.of(context).trainings,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${widget.exercises[index].name}",
                          style: FlutterFlowTheme.of(context).title3,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "${widget.exercises[index].description}",
                          style: FlutterFlowTheme.of(context).bodyText1,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Center(
                    child: Text(
                      "Fai swipe per scorrere gli esercizi della scheda",
                      style: FlutterFlowTheme.of(context).bodyText2,
                    ),
                  ),
                ),
              ],
            ),
          )
              : Container();
        },
      ),
    );
  }
}