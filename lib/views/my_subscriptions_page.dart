import 'package:flutter/material.dart';
import 'package:fc_social_fitness/viewmodels/subscription.viewmodel.dart';
import 'package:fc_social_fitness/utils/flutter_flow_theme.util.dart';
import 'package:lottie/lottie.dart';
import 'package:stacked/stacked.dart';

class MySubscriptionsPage extends StatelessWidget {
  const MySubscriptionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SubscriptionViewModel>.reactive(
      viewModelBuilder: () => SubscriptionViewModel(context),
      onViewModelReady: (vm) => vm.initialise(),
      builder: (context, vm, child) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: Text('I tuoi Abbonamenti', style: FlutterFlowTheme.of(context).title3),
            backgroundColor: FlutterFlowTheme.of(context).trainings,
          ),
          body: vm.isBusy
              ? Center(
            child: LottieBuilder.asset(
              'assets/animations/loading_animation.json',
              width: 150,
              height: 150,
              fit: BoxFit.fill,
            ),
          )
              : vm.userSubscriptions.isEmpty
              ? Center(
            child: Text(
              'Nessun abbonamento trovato',
              style: FlutterFlowTheme.of(context).title1,
            ),
          )
              : ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            itemCount: vm.userSubscriptions.length,
            itemBuilder: (context, index) {
              final subscription = vm.userSubscriptions[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).trainings,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        subscription.title ?? 'N/A',
                        style: FlutterFlowTheme.of(context).title1,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        subscription.dueSubscriptionDate != null
                            ? "Scadenza: ${subscription.dueSubscriptionDate!.toLocal().toString().split(' ')[0]}"
                            : "Scadenza non disponibile",
                        style: FlutterFlowTheme.of(context).bodyText1,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: FlutterFlowTheme.of(context).course20,
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                        },
                        child: Text(
                          'Gestisci',
                          style: FlutterFlowTheme.of(context)
                              .bodyText1
                              .copyWith(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}