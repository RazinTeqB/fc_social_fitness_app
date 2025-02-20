import 'package:http/http.dart' as http;
import 'dart:convert';

class TwilioService {
  final String accountSid = 'ACd1b1e6c8953facf1dfc6a699c544e7e8';  // SID del tuo account Twilio
  final String authToken = '832240f7948a0c6cdeae6cf1b039d900';    // Token di autenticazione Twilio
  final String twilioWhatsappNumber = 'whatsapp:+14155238886'; // Numero Twilio WhatsApp sandbox

  Future<void> sendWhatsAppMessage(String toNumber, String message) async {
    final String url = 'https://api.twilio.com/2010-04-01/Accounts/$accountSid/Messages.json';

    final Map<String, String> body = {
      'From': twilioWhatsappNumber,  // Numero Twilio WhatsApp
      'To': 'whatsapp:$toNumber',    // Numero di destinazione WhatsApp (formato internazionale)
      'Body': message                // Il testo del messaggio
    };

    final String basicAuth = 'Basic ' + base64Encode(utf8.encode('$accountSid:$authToken'));

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': basicAuth,
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );

      if (response.statusCode == 201) {
        print('Messaggio WhatsApp inviato con successo!');
      } else {
        print('Errore nell\'invio del messaggio WhatsApp: ${response.body}');
      }
    } catch (e) {
      print('Errore durante l\'invio del messaggio WhatsApp: $e');
    }
  }
}