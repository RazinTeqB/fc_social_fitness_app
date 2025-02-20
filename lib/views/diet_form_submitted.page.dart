import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fc_social_fitness/constants/app_routes.dart';
import '../utils/flutter_flow_theme.util.dart';

class DietFormSubmittedPage extends StatefulWidget {
  @override
  _DietFormSubmittedPageState createState() =>
      _DietFormSubmittedPageState();
}

class _DietFormSubmittedPageState extends State<DietFormSubmittedPage> {
  String? _pdfUrl;
  bool _isLoading = true;
  bool _isPdfAvailable = false;

  @override
  void initState() {
    super.initState();
    _fetchPdfUrl();
  }

  Future<void> _fetchPdfUrl() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('auth_token');

      if (token == null) {
        print("Token non trovato nello SharedPreferences.");
        return;
      }
      final response = await http.get(
        Uri.parse('https://gestionale.fcsocialfitness.it/api/questionari/getQuestionariNutrizione'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['questionari'] != null && responseData['questionari'].isNotEmpty) {
          final questionario = responseData['questionari'][0];
          setState(() {
            _pdfUrl = questionario['dieta_pdf'];
            _isPdfAvailable = _pdfUrl != null;
          });
        }
      } else {
        setState(() {
          _isPdfAvailable = false;
        });
        print('Errore nel recuperare il PDF: ${response.statusCode}');
      }
    } catch (e) {
      print("Errore durante il recupero del PDF: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _openPdf() async {
    if (_pdfUrl != null && await canLaunch(_pdfUrl!)) {
      await launch(_pdfUrl!);
    } else {
      print('Non è possibile aprire il PDF.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grazie!'),
        backgroundColor: FlutterFlowTheme.of(context).trainingsBackground,
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator() // Mentre carica
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Grazie per aver completato il questionario!',
              style: FlutterFlowTheme.of(context).title3,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            if (_isPdfAvailable)
              ElevatedButton(
                onPressed: _openPdf,
                style: ElevatedButton.styleFrom(
                  primary: FlutterFlowTheme.of(context).primaryColor,
                  padding:
                  EdgeInsets.symmetric(horizontal: 32, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Visualizza il tuo piano alimentare',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              )
            else
              Text(
                'Il tuo piano alimentare non è ancora disponibile. Riprova più tardi.',
                textAlign: TextAlign.center,
                style: FlutterFlowTheme.of(context).bodyText1,
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}