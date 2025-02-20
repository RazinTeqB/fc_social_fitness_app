import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fc_social_fitness/utils/app_database.dart';
import 'package:fc_social_fitness/views/widgets/fitness_loading.widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../constants/app_routes.dart';
import '../../models/training.model.dart';
import '../../utils/flutter_flow_theme.util.dart';
import '../../utils/internationalization.util.dart';
import '../../viewmodels/training_categories.viewmodel.dart';

//questa pagina diventa home training

class TrainingsListWidget extends StatefulWidget {
  const TrainingsListWidget({Key? key, required this.trainings})
      : super(key: key);

  final List<Training> trainings;

  @override
  _TrainingsListWidgetState createState() => _TrainingsListWidgetState();
}

class _TrainingsListWidgetState extends State<TrainingsListWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
            padding: EdgeInsets.only(top: 70, bottom: 20),
            child: ListView.builder(
                itemCount: widget.trainings.length,
                itemBuilder: (context, i) {
                  return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.trainingDetails,
                            arguments: [
                              widget.trainings[i].trainingPlans,
                              widget.trainings[i].name
                            ]);
                      },
                      child: Container(
                        padding: EdgeInsets.only(top: 20),
                        height: 200,
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Stack(
                          children: [
                            CachedNetworkImage(
                              imageUrl: "${widget.trainings[i].trainingImage}",
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                              placeholder: (context, url) =>
                              const Center(child: FitnessLoading()),
                              errorWidget: (context, url, error) =>
                              const Center(child:Icon(Icons.error)),
                            ),

                            /* CachedNetworkImage(
                              imageUrl: "${widget.trainings[i].trainingImage}",
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              placeholder: (context, url) =>
                                  const Center(child: FitnessLoading()),
                              errorWidget: (context, url, error) =>
                                  const Center(child:Icon(Icons.error)),
                            ),*/
                            Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      FlutterFlowTheme.of(context)
                                          .black
                                          .withOpacity(0.5),
                                      FlutterFlowTheme.of(context).transparent,
                                    ],
                                  )),
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  AutoSizeText(
                                    maxLines: 2,
                                    "${widget.trainings[i].name}",
                                    style: FlutterFlowTheme.of(context)
                                        .title1
                                        .merge(TextStyle(
                                            color: FlutterFlowTheme.of(context)
                                                .white)),
                                  ),
                                  Text(
                                      "${widget.trainings[i].trainingPlans.length} schede",
                                      style: FlutterFlowTheme.of(context)
                                          .bodyText1
                                          .merge(TextStyle(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .white)))
                                ],
                              ),
                            ),
                            StreamBuilder<List<Training>>(
                                stream: AppDatabase.favouriteTrainingStream,
                                builder: (context, snapshot) {
                                  if (snapshot.data != null) {
                                    if (snapshot.data!
                                        .map((item) => item.id.toString())
                                        .contains(widget.trainings[i].id
                                            .toString())) {
                                      widget.trainings[i].favourite = true;
                                    } else {
                                      widget.trainings[i].favourite = false;
                                    }
                                  }
                                  return Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                      splashColor: Colors.transparent,
                                      icon: Icon(
                                        widget.trainings[i].favourite
                                            ? FontAwesomeIcons.solidStar
                                            : FontAwesomeIcons.star,
                                        color: FlutterFlowTheme.of(context)
                                            .course20,
                                        size: 25,
                                      ),
                                      onPressed: () {
                                        if (widget.trainings[i].favourite) {
                                          AppDatabase.deleteTraining(
                                              widget.trainings[i]);
                                        } else {
                                          AppDatabase.storeTraining(
                                              widget.trainings[i]);
                                        }
                                      },
                                    ),
                                  );
                                }),
                          ],
                        ),
                      ));
                }));
  }
}

//FEED
/*CustomScrollView(
                  slivers: <Widget>[
                    state.isBusy && list == null
                        ? SliverToBoxAdapter(
                            child: SizedBox(
                              height: context.height - 135,
                              child: CustomScreenLoader(
                                height: double.infinity,
                                width: context.width,
                                backgroundColor: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                              ),
                            ),
                          )
                        : !state.isBusy && list == null
                            ? const SliverToBoxAdapter(
                                child: EmptyList(
                                  'No Tweet added yet',
                                  subTitle:
                                      'When new Tweet added, they\'ll show up here \n Tap tweet button to add new',
                                ),
                              )
                            : SliverList(
                                delegate: SliverChildListDelegate(
                                  list!.map(
                                    (model) {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                            top: 10, left: 10, right: 10),
                                        child: Container(
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .lineColor,
                                                    blurRadius: 5,
                                                    spreadRadius: 1.1)
                                              ],
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Tweet(
                                              model: model,
                                              trailing: TweetBottomSheet()
                                                  .tweetOptionIcon(context,
                                                      model: model,
                                                      type: TweetType.Tweet,
                                                      scaffoldKey: widget.scaffoldKey),
                                              scaffoldKey: widget.scaffoldKey,
                                            )),
                                      );
                                    },
                                  ).toList(),
                                ),
                              )
                  ],
                )*/
