import 'package:fc_social_fitness/constants/app_animations.dart';
import 'package:fc_social_fitness/constants/app_routes.dart';
import 'package:fc_social_fitness/views/widgets/fitness_loading.widget.dart';
import 'package:fc_social_fitness/views/widgets/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:stacked/stacked.dart';
import '../utils/flutter_flow_theme.util.dart';
import '../viewmodels/subscription.viewmodel.dart';

class AdditionalSubscriptionPage extends StatefulWidget {
  const AdditionalSubscriptionPage({Key? key, this.dueSubscription = false})
      : super(key: key);
  final bool dueSubscription;

  @override
  State<AdditionalSubscriptionPage> createState() =>
      _AdditionalSubscriptionPageState();
}

class _AdditionalSubscriptionPageState extends State<AdditionalSubscriptionPage> {
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
                backgroundColor: FlutterFlowTheme.of(context).trainingsBackground,
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
                    "Abbonamenti Premium",
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      LottieBuilder.asset(AppAnimations.paymentSuccessfull),
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
                          color: FlutterFlowTheme.of(context).primaryColor,
                          textStyle: FlutterFlowTheme.of(context)
                              .subtitle2
                              .override(
                            fontFamily: FlutterFlowTheme.of(context).subtitle2Family,
                            color: FlutterFlowTheme.of(context).primaryBtnText,
                            useGoogleFonts: GoogleFonts.asMap().containsKey(
                                FlutterFlowTheme.of(context).subtitle2Family),
                          ),
                          elevation: 2,
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(60),
                        ),
                      ),
                    ],
                  )
                      : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      LottieBuilder.asset(AppAnimations.paymentFailed),
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
                          color: FlutterFlowTheme.of(context).primaryColor,
                          textStyle: FlutterFlowTheme.of(context)
                              .subtitle2
                              .override(
                            fontFamily: FlutterFlowTheme.of(context).subtitle2Family,
                            color: FlutterFlowTheme.of(context).primaryBtnText,
                            useGoogleFonts: GoogleFonts.asMap().containsKey(
                                FlutterFlowTheme.of(context).subtitle2Family),
                          ),
                          elevation: 2,
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(60),
                        ),
                      ),
                    ],
                  )
                      : ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    itemCount: vm.subscriptions
                        .where((subscription) => subscription.id == 2 || subscription.id == 3 || subscription.id == 4 || subscription.id == 5)
                        .length,
                    itemBuilder: (BuildContext context, int index) {
                      var filteredSubscriptions = vm.subscriptions
                          .where((subscription) => subscription.id == 2 || subscription.id == 3 || subscription.id == 4 || subscription.id == 5)
                          .toList();
                      var subscription = filteredSubscriptions[index];

                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: FlutterFlowTheme.of(context).trainings,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 10),
                              Text(
                                subscription.title ?? "",
                                style: FlutterFlowTheme.of(context).title1,
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                subscription.description ?? "",
                                style: FlutterFlowTheme.of(context).bodyText1,
                                textAlign: TextAlign.center,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "€${subscription.price?.toStringAsFixed(2)}",
                                    style: FlutterFlowTheme.of(context).title1,
                                  )
                                ],
                              ),
                              FFButtonWidget(
                                onPressed: () async {
                                  vm.price = subscription.price;
                                  await vm.initPaymentSheet(
                                    subscription: subscription,
                                    onSuccess: () {
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
                                text: "Acquista",
                                options: FFButtonOptions(
                                  width: 200,
                                  height: 50,
                                  color: FlutterFlowTheme.of(context).course20,
                                  textStyle: FlutterFlowTheme.of(context)
                                      .bodyText1
                                      .merge(const TextStyle(color: Colors.white)),
                                  elevation: 2,
                                  borderSide: const BorderSide(
                                    color: Colors.transparent,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(60),
                                ),
                              ),
                              const SizedBox(height: 10)
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        });
  }
}