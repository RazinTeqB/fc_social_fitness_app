/*import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fc_social_fitness/utils/flutter_flow.util.dart';
import 'package:fc_social_fitness/views/widgets/fitness_loading.widget.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stacked/stacked.dart';
import '../constants/app_routes.dart';
import '../models/training.model.dart';
import '../utils/app_database.dart';
import '../utils/flutter_flow_theme.util.dart';
import '../utils/internationalization.util.dart';
import '../viewmodels/dashboard.viewmodel.dart';

class DashboardPage extends StatefulWidget {
  DashboardPage({Key? key, required this.scaffoldKey}) : super(key: key);
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DashboardViewModel>.reactive(
        viewModelBuilder: () => DashboardViewModel(context),
        onViewModelReady: (vm) => vm.initialise(),
        builder: (context, vm, child) {
          return vm.isBusy || vm.currentUser==null
              ? FitnessLoading()
              : GestureDetector(
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      children: [
                        Container(
                            decoration: BoxDecoration(
                              color:
                                  FlutterFlowTheme.of(context).permanentHeader,
                              borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15)),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(height: 35),
                                _createProfileData(context, vm),
                                const SizedBox(height: 10),
                                //FC CARD
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    child: Container(
                                        child: createFlipCard(context, vm))),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: Text(
                                            "${FFLocalizations.of(context).getText('Piani personalizzati')}",
                                            style: FlutterFlowTheme.of(context)
                                                .bodyText1
                                                .merge(TextStyle(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .white))))
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Padding(
                                    padding:
                                        const EdgeInsets.symmetric(horizontal: 15),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        vm.isBusy
                                            ? const FitnessLoading()
                                            : vm.currentUser!.subscriptions!.where((element) => element.id==1).isNotEmpty
                                                ? Expanded(
                                                    child: Container(
                                                        height: 120,
                                                        child: GestureDetector(
                                                            onTap: () {
                                                              Navigator.pushNamed(context, AppRoutes.surveyPersonalTrainingRoute);
                                                            },
                                                            child: Stack(
                                                              children: [
                                                                Container(
                                                                    height: 120,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              15),
                                                                      image:
                                                                          const DecorationImage(
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        image: AssetImage(
                                                                            'assets/images/workoutplan.jpg'),
                                                                      ),
                                                                    )),
                                                                Container(
                                                                  height: 120,
                                                                  width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(
                                                                              15),
                                                                          gradient:
                                                                              LinearGradient(
                                                                            begin:
                                                                                Alignment.bottomCenter,
                                                                            end:
                                                                                Alignment.topCenter,
                                                                            colors: [
                                                                              FlutterFlowTheme.of(context).black.withOpacity(0.5),
                                                                              FlutterFlowTheme.of(context).transparent,
                                                                            ],
                                                                          )),
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(15),
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      Text(
                                                                        "${FFLocalizations.of(context).getText('Allenamenti personalizzati')}",
                                                                        maxLines:
                                                                            2,
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyText1
                                                                            .merge(TextStyle(color: FlutterFlowTheme.of(context).white)),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )
                                                              ],
                                                            ))))
                                                : Expanded(
                                                    child: Container(
                                                        height: 120,
                                                        child: GestureDetector(
                                                            onTap: () {},
                                                            child: Stack(
                                                              children: [
                                                                Container(
                                                                    height: 120,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              15),
                                                                      image:
                                                                          const DecorationImage(
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        image: AssetImage(
                                                                            'assets/images/workoutplan.jpg'),
                                                                      ),
                                                                    )),
                                                                Container(
                                                                    height: 120,
                                                                    width: MediaQuery
                                                                            .of(
                                                                                context)
                                                                        .size
                                                                        .width,
                                                                    decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius
                                                                            .circular(
                                                                                15),
                                                                        color: Colors
                                                                            .black
                                                                            .withOpacity(
                                                                                0.7)),
                                                                    padding:
                                                                        const EdgeInsets.all(0),
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          const SizedBox(height: 10),
                                                                          Icon(FontAwesomeIcons.lock,
                                                                              size: 25,
                                                                              color: FlutterFlowTheme.of(context).white),
                                                                          const SizedBox(
                                                                              height: 10),
                                                                          Expanded(
                                                                              child: AutoSizeText("${FFLocalizations.of(context).getText("Passa a Premium per sbloccare gli allenamenti personalizzati")}", maxLines: 3, style: FlutterFlowTheme.of(context).bodyText1.merge(const TextStyle(color: Colors.white)), textAlign: TextAlign.center))
                                                                        ],
                                                                      ),
                                                                    ))
                                                              ],
                                                            )))),
                                        const SizedBox(width: 15),
                                        vm.currentUser!.subscriptions!.where((element) => element.id==1).isNotEmpty
                                            ? Expanded(
                                                child: Container(
                                                    height: 120,
                                                    child: GestureDetector(
                                                        onTap: () {
                                                          Navigator.pushNamed(context, AppRoutes.dietRoute);
                                                        },
                                                        child: Stack(
                                                          children: [
                                                            Container(
                                                                height: 120,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15),
                                                                  image:
                                                                      const DecorationImage(
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    image: AssetImage(
                                                                        'assets/images/dietplan.jpg'),
                                                                  ),
                                                                )),
                                                            Container(
                                                              height: 120,
                                                              width:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                              decoration:
                                                                  BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              15),
                                                                      gradient:
                                                                          LinearGradient(
                                                                        begin: Alignment
                                                                            .bottomCenter,
                                                                        end: Alignment
                                                                            .topCenter,
                                                                        colors: [
                                                                          FlutterFlowTheme.of(context)
                                                                              .black
                                                                              .withOpacity(0.5),
                                                                          FlutterFlowTheme.of(context)
                                                                              .transparent,
                                                                        ],
                                                                      )),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(15),
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  Text(
                                                                    "${FFLocalizations.of(context).getText('Alimentazione')}",
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyText1
                                                                        .merge(TextStyle(
                                                                            color:
                                                                                FlutterFlowTheme.of(context).white)),
                                                                  ),
                                                                  /*Text("3 schede",
                                                                            style: FlutterFlowTheme.of(
                                                                                context)
                                                                                .bodyText1
                                                                                .merge(TextStyle(
                                                                                color:
                                                                                FlutterFlowTheme.of(context).white)))*/
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ))))
                                            : Expanded(
                                                child: Container(
                                                    child: Stack(
                                                children: [
                                                  Container(
                                                      height: 120,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        image:
                                                            const DecorationImage(
                                                          fit: BoxFit.cover,
                                                          image: AssetImage(
                                                              'assets/images/dietplan.jpg'),
                                                        ),
                                                      )),
                                                  Container(
                                                      padding:
                                                          EdgeInsets.all(5),
                                                      height: 120,
                                                      width: 200,
                                                      decoration: BoxDecoration(
                                                        color: Colors.black
                                                            .withOpacity(0.7),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    5.0),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            SizedBox(
                                                                height: 10),
                                                            Icon(
                                                                FontAwesomeIcons
                                                                    .lock,
                                                                size: 25,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .white),
                                                            SizedBox(
                                                                height: 10),
                                                            Expanded(
                                                                child: AutoSizeText(
                                                                    "${FFLocalizations.of(context).getText("Passa a Premium per sbloccare la sezione di alimentazione")}",
                                                                    maxLines: 3,
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyText1
                                                                        .merge(const TextStyle(
                                                                            color: Colors
                                                                                .white)),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center))
                                                          ],
                                                        ),
                                                      ))
                                                ],
                                              )))
                                      ],
                                    )),
                                SizedBox(height: 15),
                              ],
                            )),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Padding(
                                padding: EdgeInsets.only(left: 15),
                                child: Text(
                                    "${FFLocalizations.of(context).getText("Allenamenti preferiti")}",
                                    style:
                                        FlutterFlowTheme.of(context).bodyText1))
                          ],
                        ),
                        StreamBuilder<List<Training>>(
                          stream: AppDatabase.favouriteTrainingStream,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: FitnessLoading(),
                              );
                            }
                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 60),
                                child: Text(
                                  "${FFLocalizations.of(context).getText("Non hai nessun corso preferito")}",
                                  style: FlutterFlowTheme.of(context).bodyText2,
                                  textAlign: TextAlign.center,
                                ),
                              );
                            }
                            return Container(
                              height: 180,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, i) {
                                  return Container(
                                    width: 300,
                                    margin: const EdgeInsets.only(
                                        left: 15, top: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: Container(
                                              width: double.infinity,
                                              height: double.infinity,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    "${snapshot.data![i].trainingImage}",
                                                fit: BoxFit.cover,
                                              )
                                              /*Image.network(
                                                  "${snapshot.data![i].trainingImage}",
                                                  fit: BoxFit.fill, loadingBuilder:
                                                  (BuildContext context, Widget child,
                                                  ImageChunkEvent? loadingProgress) {
                                                if (loadingProgress == null) {
                                                  return child;
                                                }
                                                return const Center(child: FitnessLoading());
                                              }, errorBuilder: (context, error, stackTrace) {
                                                print(error);
                                                return const Center(child: Icon(Icons.error));
                                              }),*/
                                              ),
                                        ),
                                        GestureDetector(
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              gradient: LinearGradient(
                                                begin: Alignment.bottomCenter,
                                                end: Alignment.topCenter,
                                                colors: [
                                                  FlutterFlowTheme.of(context)
                                                      .black
                                                      .withOpacity(0.5),
                                                  FlutterFlowTheme.of(context)
                                                      .transparent,
                                                ],
                                              ),
                                            ),
                                            padding: EdgeInsets.all(15),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                AutoSizeText(
                                                  "${snapshot.data![i].name}",
                                                  maxLines: 2,
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .title1
                                                      .merge(TextStyle(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .white,
                                                      )),
                                                ),
                                                Text(
                                                  "${snapshot.data![i].trainingPlans.length} schede",
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyText1
                                                      .merge(TextStyle(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .white,
                                                      )),
                                                ),
                                              ],
                                            ),
                                          ),
                                          onTap: () {
                                            Navigator.pushNamed(
                                              context,
                                              AppRoutes.trainingDetails,
                                              arguments: [
                                                snapshot.data![i].trainingPlans,
                                                snapshot.data![i].name
                                              ],
                                            );
                                          },
                                        ),
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: IconButton(
                                            icon: Icon(
                                              FontAwesomeIcons.solidStar,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .course20,
                                              size: 25,
                                            ),
                                            onPressed: () {
                                              AppDatabase.deleteTraining(
                                                  snapshot.data![i]);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 95)
                      ],
                    ),
                  ));
        });
  }
}

Widget _createProfileData(BuildContext context, DashboardViewModel vm) {
  return Padding(
    padding: EdgeInsets.fromLTRB(15, 20, 0, 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Align(
            alignment: Alignment.centerLeft,
            child: Text(
                "${FFLocalizations.of(context).getText('saluto')} ${vm.currentUser?.userData?.name}!",
                style: FlutterFlowTheme.of(context).title1.merge(
                    TextStyle(color: FlutterFlowTheme.of(context).white)))),
        SizedBox(height: 10),
        Align(
            alignment: Alignment.centerLeft,
            child: Text(
                "${FFLocalizations.of(context).getText("La tua FC Card")}",
                style: FlutterFlowTheme.of(context).bodyText1.merge(
                    TextStyle(color: FlutterFlowTheme.of(context).white))))
      ],
    ),
  );
}

Widget createFlipCard(BuildContext context, DashboardViewModel vm) {
  return FlipCard(
    alignment: Alignment.center,
    fill: Fill.fillBack,
    // Fill the back side of the card to make in the same size as the front.
    direction: FlipDirection.HORIZONTAL,
    // default
    front: Container(
      height: 200,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: FlutterFlowTheme.of(context).lineColor,
              blurRadius: 2,
              spreadRadius: 2,
              offset: Offset(0, 0)),
        ],
        color: FlutterFlowTheme.of(context).white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${FFLocalizations.of(context).getText('Nome e cognome')}:",
                            style: FlutterFlowTheme.of(context)
                                .bodyText1
                                .merge(TextStyle(color: Colors.white)),
                          ),
                          Text(
                            "${vm.currentUser?.userData?.name}",
                            style: FlutterFlowTheme.of(context)
                                .bodyText1
                                .merge(TextStyle(color: Colors.white)),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.center,
            child: Image.asset(
              "assets/images/logocrop.png",
              height: 70,
              width: 70,
            ),
          ),
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${FFLocalizations.of(context).getText('Scadenza abbonamento')}:",
                  style: FlutterFlowTheme.of(context)
                      .bodyText1
                      .merge(TextStyle(color: Colors.white)),
                ),
                /*GestureDetector(
                  onTap: () {
                    /* Navigator.pushNamed(context, AppRoutes.subscriptionRoute,
                        arguments: false);*/
                    Navigator.pushNamed(context, AppRoutes.subscriptionRoute);
                  },
                  child: Text(
                    "${dateTimeFormat("dd-MM-yyyy", vm.currentUser!.dueSubscriptionDate)}",
                    style: FlutterFlowTheme.of(context)
                        .bodyText1
                        .merge(TextStyle(color: Colors.lightGreenAccent)),
                  ),
                ),*/
              ],
            ),
          ),
        ],
      ),
    ),

    back: Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: FlutterFlowTheme.of(context).lineColor,
                  blurRadius: 2,
                  spreadRadius: 2,
                  offset: Offset(0, 0)),
            ],
            color: FlutterFlowTheme.of(context).white,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.all(15),
          height: 200,
          width: MediaQuery.of(context).size.width,
        ),
        Container(
            height: 200,
            width: 400,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${FFLocalizations.of(context).getText('Nome utente')}:",
                                      style: FlutterFlowTheme.of(context)
                                          .bodyText1
                                          .merge(
                                              TextStyle(color: Colors.white)),
                                    ),
                                    Text(
                                      "${vm.currentUser?.username}",
                                      style: FlutterFlowTheme.of(context)
                                          .bodyText1
                                          .merge(
                                              TextStyle(color: Colors.white)),
                                    )
                                  ],
                                )),
                            SizedBox(height: 10),
                            Container(
                                width: 380,
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Email:",
                                      style: FlutterFlowTheme.of(context)
                                          .bodyText1
                                          .merge(
                                              TextStyle(color: Colors.white)),
                                    ),
                                    Text(
                                      "${vm.currentUser?.email}",
                                      style: FlutterFlowTheme.of(context)
                                          .bodyText1
                                          .merge(
                                              TextStyle(color: Colors.white)),
                                    )
                                  ],
                                ))
                          ]),
                    ),
                  ],
                ),
                const SizedBox(height: 10, width: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Container(
                            height: 35,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${FFLocalizations.of(context).getText('altezza')}:",
                                  style: FlutterFlowTheme.of(context)
                                      .bodyText1
                                      .merge(TextStyle(color: Colors.white)),
                                ),
                                Text(
                                  "${vm.currentUser?.userData?.height}",
                                  style: FlutterFlowTheme.of(context)
                                      .bodyText1
                                      .merge(TextStyle(color: Colors.white)),
                                )
                              ],
                            ))),
                    const SizedBox(width: 6),
                    Expanded(
                        child: Container(
                            height: 35,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${FFLocalizations.of(context).getText('peso')}:",
                                  style: FlutterFlowTheme.of(context)
                                      .bodyText1
                                      .merge(TextStyle(color: Colors.white)),
                                ),
                                Text(
                                  "${vm.currentUser?.userData?.weight}",
                                  style: FlutterFlowTheme.of(context)
                                      .bodyText1
                                      .merge(TextStyle(color: Colors.white)),
                                ),
                              ],
                            ))),
                    SizedBox(width: 5),
                    Expanded(
                        child: Container(
                            height: 35,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    child: AutoSizeText(
                                  "${FFLocalizations.of(context).getText('sesso')}:",
                                  style: FlutterFlowTheme.of(context)
                                      .bodyText1
                                      .merge(TextStyle(color: Colors.white)),
                                  maxLines: 1,
                                )),
                                Expanded(
                                    child: AutoSizeText(
                                  (vm.currentUser?.userData?.gender == '0')
                                      ? FFLocalizations.of(context)
                                          .getText('uomo')
                                      : (vm.currentUser?.userData?.gender ==
                                              '1')
                                          ? FFLocalizations.of(context)
                                              .getText('donna')
                                          : FFLocalizations.of(context)
                                              .getText('altro'),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyText1
                                      .merge(TextStyle(color: Colors.white)),
                                  maxLines: 1,
                                ))
                              ],
                            )))
                  ],
                ),
                SizedBox(height: 10),
                Expanded(
                    child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: vm.currentUser!.userData!.bio != null
                            ? AutoSizeText(
                                "Bio: ${vm.currentUser!.userData!.bio!}",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                style: FlutterFlowTheme.of(context)
                                    .bodyText1
                                    .merge(TextStyle(
                                        color: FlutterFlowTheme.of(context)
                                            .white)),
                              )
                            : AutoSizeText(
                                "Bio: ",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                style: FlutterFlowTheme.of(context)
                                    .bodyText1
                                    .merge(TextStyle(
                                        color: FlutterFlowTheme.of(context)
                                            .white)),
                              ))),
              ],
            )),
      ],
    ),
  );
}*/
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fc_social_fitness/views/widgets/fitness_loading.widget.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stacked/stacked.dart';
import '../constants/app_routes.dart';
import '../models/training.model.dart';
import '../utils/app_database.dart';
import '../utils/flutter_flow_theme.util.dart';
import '../utils/internationalization.util.dart';
import '../viewmodels/dashboard.viewmodel.dart';

class DashboardPage extends StatefulWidget {
  DashboardPage({Key? key, required this.scaffoldKey}) : super(key: key);
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DashboardViewModel>.reactive(
      viewModelBuilder: () => DashboardViewModel(context),
      onViewModelReady: (vm) => vm.initialise(),
      builder: (context, vm, child) {
        return vm.isBusy || vm.currentUser == null
            ? FitnessLoading()
            : GestureDetector(
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).permanentHeader,
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15)),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 35),
                            _createProfileData(context, vm),
                            const SizedBox(height: 10),
                            // FC CARD
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Container(
                                    child: createFlipCard(context, vm))),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Text(
                                    "${FFLocalizations.of(context).getText('Piani personalizzati')}",
                                    style: FlutterFlowTheme.of(context)
                                        .bodyText1
                                        .merge(TextStyle(
                                            color: FlutterFlowTheme.of(context)
                                                .white)),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  vm.isBusy
                                      ? const FitnessLoading()
                                      : _buildConditionalAccess(vm, context),
                                  const SizedBox(width: 15),
                                  _buildDietSection(vm, context),
                                ],
                              ),
                            ),
                            SizedBox(height: 15),
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 15),
                            child: Text(
                              "${FFLocalizations.of(context).getText("Allenamenti preferiti")}",
                              style: FlutterFlowTheme.of(context).bodyText1,
                            ),
                          ),
                        ],
                      ),
                      _buildFavoriteTrainings(context),
                      SizedBox(height: 95),
                    ],
                  ),
                ),
              );
      },
    );
  }

  Widget _buildConditionalAccess(DashboardViewModel vm, BuildContext context) {
    // Filtra gli abbonamenti dell'utente per vedere se ha accesso
    bool hasSubscription = vm.currentUser!.subscriptions!
        .where((element) => element.id == 2 || element.id == 4)
        .isNotEmpty;

    return Expanded(
      child: Container(
        height: 120,
        child: GestureDetector(
          onTap: () {
            if (hasSubscription) {
              // Se ha l'abbonamento valido, naviga alla pagina degli allenamenti personalizzati
              Navigator.pushNamed(
                  context, AppRoutes.surveyPersonalTrainingRoute);
            } else {
              // Altrimenti, naviga alla pagina per acquistare gli abbonamenti richiesti
              Navigator.pushNamed(
                  context, AppRoutes.additionalSubscriptionRoute);
            }
          },
          child: Stack(
            children: [
              Container(
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: const DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/workoutplan.jpg'),
                  ),
                ),
              ),
              Container(
                height: 120,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      FlutterFlowTheme.of(context).black.withOpacity(0.5),
                      FlutterFlowTheme.of(context).transparent,
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "${FFLocalizations.of(context).getText(hasSubscription ? 'Allenamenti personalizzati' : 'Passa a Premium per sbloccare gli allenamenti')}",
                      maxLines: 2,
                      style: FlutterFlowTheme.of(context).bodyText1.merge(
                          TextStyle(color: FlutterFlowTheme.of(context).white)),
                    ),
                  ],
                ),
              ),
              if (!hasSubscription)
                Align(
                  alignment: Alignment.center,
                  child: Icon(
                    FontAwesomeIcons.lock,
                    size: 25,
                    color: FlutterFlowTheme.of(context).white,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDietSection(DashboardViewModel vm, BuildContext context) {
    bool hasDietSubscription = vm.currentUser!.subscriptions!.where((element) => element.id == 3 || element.id == 4 || element.id == 5).isNotEmpty;
    return Expanded(
      child: Container(
        height: 120,
        child: GestureDetector(
          onTap: () {
            if (hasDietSubscription) {
              Navigator.pushNamed(context, AppRoutes.dietRoute);
            } else {
              Navigator.pushNamed(
                  context, AppRoutes.additionalSubscriptionRoute);
            }
          },
          child: Stack(
            children: [
              Container(
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: const DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/dietplan.jpg'),
                  ),
                ),
              ),
              Container(
                height: 120,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      FlutterFlowTheme.of(context).black.withOpacity(0.5),
                      FlutterFlowTheme.of(context).transparent,
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "${FFLocalizations.of(context).getText(hasDietSubscription ? 'Alimentazione' : 'Passa a Premium per sbloccare la sezione di alimentazione')}",
                      style: FlutterFlowTheme.of(context).bodyText1.merge(
                          TextStyle(color: FlutterFlowTheme.of(context).white)),
                    ),
                  ],
                ),
              ),
              if (!hasDietSubscription)
                Align(
                  alignment: Alignment.center,
                  child: Icon(
                    FontAwesomeIcons.lock,
                    size: 25,
                    color: FlutterFlowTheme.of(context).white,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /*Widget _buildFavoriteTrainings(BuildContext context) {
    return StreamBuilder<List<Training>>(
      stream: AppDatabase.favouriteTrainingStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: FitnessLoading());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 60),
            child: Text(
              "${FFLocalizations.of(context).getText("Non hai nessun corso preferito")}",
              style: FlutterFlowTheme.of(context).bodyText2,
              textAlign: TextAlign.center,
            ),
          );
        }
        return Container(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, i) {
              return Container(
                width: 300,
                margin: const EdgeInsets.only(left: 15, top: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: CachedNetworkImage(
                        imageUrl: snapshot.data![i].trainingImage!,
                        fit: BoxFit.cover,
                      ),
                    ),
                    GestureDetector(
                      child: Container(
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
                          ),
                        ),
                        padding: EdgeInsets.all(15),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AutoSizeText(
                              snapshot.data![i].name!,
                              maxLines: 2,
                              style: FlutterFlowTheme.of(context).title1.merge(
                                  TextStyle(
                                      color:
                                          FlutterFlowTheme.of(context).white)),
                            ),
                            Text(
                              "${snapshot.data![i].trainingPlans.length} schede",
                              style: FlutterFlowTheme.of(context)
                                  .bodyText1
                                  .merge(TextStyle(
                                      color:
                                          FlutterFlowTheme.of(context).white)),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.trainingDetails,
                          arguments: [
                            snapshot.data![i].trainingPlans,
                            snapshot.data![i].name
                          ],
                        );
                      },
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: Icon(
                          FontAwesomeIcons.solidStar,
                          color: FlutterFlowTheme.of(context).course20,
                          size: 25,
                        ),
                        onPressed: () {
                          AppDatabase.deleteTraining(snapshot.data![i]);
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }*/
  Widget _buildFavoriteTrainings(BuildContext context) {
    return StreamBuilder<List<Training>>(
      stream: AppDatabase.favouriteTrainingStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: FitnessLoading());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 30),
            child: Text(
              "${FFLocalizations.of(context).getText("Non hai nessun corso preferito")}",
              style: FlutterFlowTheme.of(context).bodyText2,
              textAlign: TextAlign.center,
            ),
          );
        }
        return SizedBox(
          height: 300,
          child: ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, i) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CachedNetworkImage(
                        imageUrl: snapshot.data![i].trainingImage!,
                        fit: BoxFit.cover,
                        height: 100,
                        width: double.infinity,
                      ),
                    ),
                    GestureDetector(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              FlutterFlowTheme.of(context)
                                  .black
                                  .withOpacity(0.5),
                              FlutterFlowTheme.of(context).transparent,
                            ],
                          ),
                        ),
                        padding: EdgeInsets.all(10), // Ridurre il padding all'interno della card
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AutoSizeText(
                              snapshot.data![i].name!,
                              maxLines: 2,
                              style: FlutterFlowTheme.of(context).title2.merge(
                                  TextStyle(
                                      color:
                                      FlutterFlowTheme.of(context).white)),
                            ),
                            Text(
                              "${snapshot.data![i].trainingPlans.length} schede",
                              style: FlutterFlowTheme.of(context)
                                  .bodyText2
                                  .merge(TextStyle(
                                  color:
                                  FlutterFlowTheme.of(context).white)),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.trainingDetails,
                          arguments: [
                            snapshot.data![i].trainingPlans,
                            snapshot.data![i].name
                          ],
                        );
                      },
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: Icon(
                          FontAwesomeIcons.solidStar,
                          color: FlutterFlowTheme.of(context).course20,
                          size: 25, // Riduzione della dimensione dell'icona
                        ),
                        onPressed: () {
                          AppDatabase.deleteTraining(snapshot.data![i]);
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

Widget _createProfileData(BuildContext context, DashboardViewModel vm) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(15, 20, 0, 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "${FFLocalizations.of(context).getText("saluto")} ${vm.currentUser?.userData?.name}!",
            style: FlutterFlowTheme.of(context)
                .title1
                .merge(TextStyle(color: FlutterFlowTheme.of(context).white)),
          ),
        ),
        SizedBox(height: 10),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "${FFLocalizations.of(context).getText("La tua FC Card")}",
            style: FlutterFlowTheme.of(context)
                .bodyText1
                .merge(TextStyle(color: FlutterFlowTheme.of(context).white)),
          ),
        ),
      ],
    ),
  );
}

Widget createFlipCard(BuildContext context, DashboardViewModel vm) {
  return FlipCard(
    alignment: Alignment.center,
    fill: Fill.fillBack,
    direction: FlipDirection.HORIZONTAL,
    front: Container(
      height: 200,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: FlutterFlowTheme.of(context).lineColor,
            blurRadius: 2,
            spreadRadius: 2,
            offset: const Offset(0, 0),
          ),
        ],
        color: FlutterFlowTheme.of(context).white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${FFLocalizations.of(context).getText("Nome e cognome")}:",
                            style: FlutterFlowTheme.of(context)
                                .bodyText1
                                .merge(TextStyle(color: Colors.white)),
                          ),
                          Text(
                            "${vm.currentUser?.userData?.name}",
                            style: FlutterFlowTheme.of(context)
                                .bodyText1
                                .merge(TextStyle(color: Colors.white)),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.center,
            child: Image.asset(
              "assets/images/logocrop.png",
              height: 70,
              width: 70,
            ),
          ),
          SizedBox(height: 17,)
          /*Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${FFLocalizations.of(context).getText("Scadenza abbonamento")}:",
                  style: FlutterFlowTheme.of(context)
                      .bodyText1
                      .merge(TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),*/
        ],
      ),
    ),
    back: Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: FlutterFlowTheme.of(context).lineColor,
                blurRadius: 2,
                spreadRadius: 2,
                offset: Offset(0, 0),
              ),
            ],
            color: FlutterFlowTheme.of(context).white,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(15),
          height: 200,
          width: MediaQuery.of(context).size.width,
        ),
        Container(
          height: 200,
          width: 400,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${FFLocalizations.of(context).getText("Nome utente")}:",
                                style: FlutterFlowTheme.of(context)
                                    .bodyText1
                                    .merge(TextStyle(color: Colors.white)),
                              ),
                              Text(
                                "${vm.currentUser?.username}",
                                style: FlutterFlowTheme.of(context)
                                    .bodyText1
                                    .merge(TextStyle(color: Colors.white)),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: 380,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Email:",
                                style: FlutterFlowTheme.of(context)
                                    .bodyText1
                                    .merge(TextStyle(color: Colors.white)),
                              ),
                              Text(
                                "${vm.currentUser?.email}",
                                style: FlutterFlowTheme.of(context)
                                    .bodyText1
                                    .merge(TextStyle(color: Colors.white)),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10, width: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      height: 35,
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${FFLocalizations.of(context).getText("altezza")}:",
                            style: FlutterFlowTheme.of(context)
                                .bodyText1
                                .merge(TextStyle(color: Colors.white)),
                          ),
                          Text(
                            "${vm.currentUser?.userData?.height}",
                            style: FlutterFlowTheme.of(context)
                                .bodyText1
                                .merge(TextStyle(color: Colors.white)),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Container(
                      height: 35,
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${FFLocalizations.of(context).getText("peso")}:",
                            style: FlutterFlowTheme.of(context)
                                .bodyText1
                                .merge(TextStyle(color: Colors.white)),
                          ),
                          Text(
                            "${vm.currentUser?.userData?.weight}",
                            style: FlutterFlowTheme.of(context)
                                .bodyText1
                                .merge(TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    child: Container(
                      height: 35,
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: AutoSizeText(
                              "${FFLocalizations.of(context).getText("sesso")}:",
                              style: FlutterFlowTheme.of(context)
                                  .bodyText1
                                  .merge(TextStyle(color: Colors.white)),
                              maxLines: 1,
                            ),
                          ),
                          Expanded(
                            child: AutoSizeText(
                              (vm.currentUser?.userData?.gender == '1')
                                  ? FFLocalizations.of(context).getText("uomo")
                                  : (vm.currentUser?.userData?.gender == "‘1’")
                                      ? FFLocalizations.of(context)
                                          .getText("donna")
                                      : FFLocalizations.of(context)
                                          .getText("altro"),
                              style: FlutterFlowTheme.of(context)
                                  .bodyText1
                                  .merge(TextStyle(color: Colors.white)),
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: vm.currentUser!.userData!.bio != null
                      ? AutoSizeText(
                          "Bio: ${vm.currentUser!.userData!.bio!}",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: FlutterFlowTheme.of(context).bodyText1.merge(
                              TextStyle(
                                  color: FlutterFlowTheme.of(context).white)),
                        )
                      : AutoSizeText(
                          "Bio: ",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: FlutterFlowTheme.of(context).bodyText1.merge(
                              TextStyle(
                                  color: FlutterFlowTheme.of(context).white)),
                        ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
