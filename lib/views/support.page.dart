import 'package:flutter/material.dart';
import 'package:fc_social_fitness/utils/flutter_flow_theme.util.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({Key? key}) : super(key: key);

  Future<void> _sendEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'supporto@fcsocialfitness.it',
      queryParameters: {
        'subject': 'Richiesta di Assistenza'
      },
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Non è possibile aprire l\'app email';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assistenza', style: FlutterFlowTheme.of(context).title3),
        backgroundColor: FlutterFlowTheme.of(context).trainings,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Hai bisogno di assistenza?',
              style: FlutterFlowTheme.of(context).title1,
              textAlign: TextAlign.center,
            ),
             SizedBox(height: 20),
            Text(
              'Per qualsiasi problema o richiesta di supporto, puoi inviarci un\'email direttamente cliccando il pulsante qui sotto.',
              style: FlutterFlowTheme.of(context).bodyText1,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _sendEmail,
              style: ElevatedButton.styleFrom(
                backgroundColor: FlutterFlowTheme.of(context).course20,
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 5,
              ),
              child: Text(
                'Contatta il Supporto',
                style: FlutterFlowTheme.of(context).subtitle2.copyWith(
                  color: FlutterFlowTheme.of(context).primaryBtnText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}