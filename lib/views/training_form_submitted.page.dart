import 'package:fc_social_fitness/constants/app_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils/flutter_flow_theme.util.dart';

class TrainingFormSubmittedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grazie!'),
        backgroundColor: FlutterFlowTheme.of(context).trainingsBackground,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Grazie per aver completato il questionario!',
              style: FlutterFlowTheme.of(context).title3,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, AppRoutes.workoutPlanRoute);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: FlutterFlowTheme.of(context).course20,
                textStyle: FlutterFlowTheme.of(context)
                    .bodyText1
                    .merge(const TextStyle(color: Colors.white)),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Clicca qui per il tuo piano di allenamento personalizzato',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}