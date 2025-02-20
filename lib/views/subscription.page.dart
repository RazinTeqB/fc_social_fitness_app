import 'package:fc_social_fitness/constants/app_animations.dart';
import 'package:fc_social_fitness/constants/app_routes.dart';
import 'package:fc_social_fitness/views/widgets/fitness_loading.widget.dart';
import 'package:fc_social_fitness/views/widgets/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:stacked/stacked.dart';
import '../../viewmodels/subscription.viewmodel.dart';
import '../utils/flutter_flow_theme.util.dart';
import '../utils/internationalization.util.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({Key? key, this.dueSubscription = false})
      : super(key: key);
  final bool dueSubscription;

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  bool threeMonthSelected = false;
  bool sixMonthSelected = false;
  bool yearSelected = false;
  bool paymentCompleted = false;
  bool paymentSuccessfull = false;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SubscriptionViewModel>.reactive(
        viewModelBuilder: () => SubscriptionViewModel(context),
        onViewModelReady: (vm) => vm.initialise(),
        builder: (context, vm, child) {
          return vm.isBusy
              ? FitnessLoading()
              : GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: WillPopScope(
                      onWillPop: () async => false,
                      child: Scaffold(
                        backgroundColor:
                            FlutterFlowTheme.of(context).trainingsBackground,
                        appBar: !paymentCompleted
                            ? AppBar(
                                elevation: 0,
                                centerTitle: true,
                                leading: widget.dueSubscription
                                    ? GestureDetector(
                                        onTap: () async {
                                          await vm.doLogout();
                                        },
                                        child: Center(
                                          child: Text(
                                            "Esci",
                                            style: FlutterFlowTheme.of(context)
                                                .bodyText1
                                                .merge(TextStyle(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .course20)),
                                          ),
                                        ))
                                    : IconButton(
                                        icon: Icon(Icons.arrow_back_ios_new,
                                            size: 20,
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText),
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                      ),
                                automaticallyImplyLeading: false,
                                title: Text(
                                  "Abbonamenti",
                                  style: FlutterFlowTheme.of(context).title3,
                                ),
                                backgroundColor:
                                    FlutterFlowTheme.of(context).trainings,
                              )
                            : null,
                        body: Container(
                          alignment: Alignment.center,
                          child: paymentCompleted
                              ? paymentSuccessfull
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        LottieBuilder.asset(
                                            AppAnimations.paymentSuccessfull),
                                        Text("Hai pagato"),
                                        FFButtonWidget(
                                          onPressed: () async {
                                            Navigator.pushNamed(
                                                context, AppRoutes.homeRoute,
                                                arguments: 0);
                                          },
                                          text: "Inizia ad allenarti",
                                          options: FFButtonOptions(
                                            width: 270,
                                            height: 50,
                                            color: FlutterFlowTheme.of(context)
                                                .primaryColor,
                                            textStyle:
                                                FlutterFlowTheme.of(context)
                                                    .subtitle2
                                                    .override(
                                                      fontFamily:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .subtitle2Family,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryBtnText,
                                                      useGoogleFonts: GoogleFonts
                                                              .asMap()
                                                          .containsKey(
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .subtitle2Family),
                                                    ),
                                            elevation: 2,
                                            borderSide: const BorderSide(
                                              color: Colors.transparent,
                                              width: 1,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(60),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        LottieBuilder.asset(
                                            AppAnimations.paymentFailed),
                                        Text("Pagamento fallito"),
                                        FFButtonWidget(
                                          onPressed: () async {
                                            setState(() {
                                              paymentCompleted = false;
                                            });
                                          },
                                          text: "Ritenta pagamento",
                                          options: FFButtonOptions(
                                            width: 270,
                                            height: 50,
                                            color: FlutterFlowTheme.of(context)
                                                .primaryColor,
                                            textStyle:
                                                FlutterFlowTheme.of(context)
                                                    .subtitle2
                                                    .override(
                                                      fontFamily:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .subtitle2Family,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryBtnText,
                                                      useGoogleFonts: GoogleFonts
                                                              .asMap()
                                                          .containsKey(
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .subtitle2Family),
                                                    ),
                                            elevation: 2,
                                            borderSide: const BorderSide(
                                              color: Colors.transparent,
                                              width: 1,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(60),
                                          ),
                                        ),
                                      ],
                                    )
                              : ListView.builder(
                                  physics: const ClampingScrollPhysics(),
                                  itemCount: vm.subscriptions.where((subscription) => [1, 5, 6, 7, 8].contains(subscription.id)).length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    var filteredSubscriptions = vm.subscriptions.where((subscription) => [1, 5, 6, 7, 8].contains(subscription.id)).toList();
                                    return Padding(
                                        padding: const EdgeInsets.only(
                                            top: 15, right: 15, left: 15),
                                        child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: FlutterFlowTheme.of(context).trainings,
                                            ),
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const SizedBox(height: 10),
                                                  Text(
                                                      textAlign: TextAlign.center,
                                                      "${filteredSubscriptions[index].title}",
                                                      style: FlutterFlowTheme.of(context).title1),
                                                  Text(
                                                      textAlign: TextAlign.center,
                                                      "${filteredSubscriptions[index].description}",
                                                      style: FlutterFlowTheme.of(context).bodyText1),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                          "€${filteredSubscriptions[index].price?.toStringAsFixed(2)}",
                                                          style: FlutterFlowTheme.of(context).title1)
                                                    ],
                                                  ),
                                                  /*ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                  FlutterFlowTheme
                                                      .of(
                                                      context)
                                                      .course20),
                                              onPressed: () {
                                                vm.price = vm
                                                    .subscriptions[
                                                index]
                                                    .price;
                                                vm.initPaymentSheet(
                                                    onSuccess: () {
                                                      setState(() {
                                                        paymentCompleted =
                                                        true;
                                                        paymentSuccessfull =
                                                        true;
                                                      });
                                                    }, onFail: () {
                                                  setState(() {
                                                    paymentCompleted =
                                                    true;
                                                    paymentSuccessfull =
                                                    false;
                                                  });
                                                });
                                              },
                                              child: Text(
                                                FFLocalizations.of(
                                                    context)
                                                    .getText('scegli'),
                                                style: FlutterFlowTheme
                                                    .of(context)
                                                    .bodyText1
                                                    .merge(const TextStyle(
                                                    color: Colors
                                                        .white)),
                                              )),*/
                                                  ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .course20,
                                                    ),
                                                    onPressed: () async {vm.price = filteredSubscriptions[index].price;
                                                      await vm.initPaymentSheet(subscription:vm.subscriptions[index], onSuccess: () {
                                                          setState(() {
                                                            paymentCompleted = true;
                                                            paymentSuccessfull = true;
                                                          });
                                                        },
                                                        onFail: () {
                                                          setState(() {
                                                            paymentCompleted = true;
                                                            paymentSuccessfull = false;
                                                          });
                                                        },
                                                      );
                                                    },
                                                    child: Text(
                                                      FFLocalizations.of(context).getText('scegli'),
                                                      style:
                                                          FlutterFlowTheme.of(context).bodyText1.merge(const TextStyle(color: Colors.white),
                                                              ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10)
                                                ]))) /*threeMonthSubTile(vm)*/;
                                  }),
                        ),
                      )));
        });
  }
//qua finisce il codice attuale
/*  threeMonthSubTile(SubscriptionViewModel vm) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        elevation: 4,
        color: threeMonthSelected
            ? const Color(0xFF39D2C0)
            : FlutterFlowTheme.of(context).secondaryBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '1 mese',
                style: FlutterFlowTheme.of(context).bodyText3,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                '30.00 €',
                style: FlutterFlowTheme.of(context).title1,
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.done,
                      color: threeMonthSelected ? Colors.white : Colors.black,
                    ),
                    title: Text(FFLocalizations.of(context).getText('info'),
                        style: AppTextStyle.h3TitleTextStyle(
                            color: yearSelected ? Colors.white : Colors.black)),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.done,
                      color: threeMonthSelected ? Colors.white : Colors.black,
                    ),
                    title: Text(FFLocalizations.of(context).getText('info'),
                        style: AppTextStyle.h3TitleTextStyle(
                            color: yearSelected ? Colors.white : Colors.black)),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.done,
                      color: threeMonthSelected ? Colors.white : Colors.black,
                    ),
                    title: Text(FFLocalizations.of(context).getText('info'),
                        style: AppTextStyle.h3TitleTextStyle(
                            color: yearSelected ? Colors.white : Colors.black)),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 180,
                height: 40,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: threeMonthSelected
                            ? Colors.white
                            : const Color(0xFF39D2C0)),
                    onPressed: () {
                      vm.initPaymentSheet(onSuccess: () {
                        setState(() {
                          paymentCompleted = true;
                          paymentSuccessfull = true;
                        });
                      }, onFail: () {
                        setState(() {
                          paymentCompleted = true;
                          paymentSuccessfull = false;
                        });
                      });
                    },
                    child: Text(
                      FFLocalizations.of(context).getText('scegli'),
                      style: AppTextStyle.h3TitleTextStyle(
                          color: FlutterFlowTheme.of(context).secondaryColor),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  sixMonthSubTile() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0),
      child: Card(
        elevation: 4,
        color: sixMonthSelected
            ? const Color(0xFF39D2C0)
            : FlutterFlowTheme.of(context).secondaryBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '6 mesi',
                style: FlutterFlowTheme.of(context).bodyText3,
              ),
              SizedBox(
                height: 20,
              ),
              Text('60.00 €', style: FlutterFlowTheme.of(context).title1),
              SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.done,
                      color: sixMonthSelected ? Colors.white : Colors.black,
                    ),
                    title: Text(FFLocalizations.of(context).getText('info'),
                        style: AppTextStyle.h3TitleTextStyle(
                            color: yearSelected ? Colors.white : Colors.black)),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              sixMonthSelected
                  ? SizedBox(
                      width: 180,
                      height: 40,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: sixMonthSelected
                                  ? Colors.white
                                  : const Color(0xFF39D2C0)),
                          onPressed: () {},
                          child: Text(
                            FFLocalizations.of(context).getText('scegli'),
                            style: AppTextStyle.h3TitleTextStyle(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryColor),
                          )),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  yearSubTile() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        elevation: 4,
        color: yearSelected
            ? const Color(0xFF39D2C0)
            : FlutterFlowTheme.of(context).secondaryBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '12 mesi',
                style: FlutterFlowTheme.of(context).bodyText3,
              ),
              SizedBox(
                height: 20,
              ),
              Text('90.00 €', style: FlutterFlowTheme.of(context).title1),
              SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.done,
                      color: yearSelected ? Colors.white : Colors.black,
                    ),
                    title: Text(FFLocalizations.of(context).getText('info'),
                        style: AppTextStyle.h3TitleTextStyle(
                            color: yearSelected ? Colors.white : Colors.black)),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              yearSelected
                  ? SizedBox(
                      width: 180,
                      height: 40,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: yearSelected
                                  ? Colors.white
                                  : FlutterFlowTheme.of(context)
                                      .secondaryColor),
                          onPressed: () {},
                          child: Text(
                            FFLocalizations.of(context).getText('scegli'),
                            style: AppTextStyle.h3TitleTextStyle(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryColor),
                          )),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}*/
}
