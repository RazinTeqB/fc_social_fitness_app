import 'package:flutter/cupertino.dart';
import '../constants/api.dart';
import '../services/http.service.dart';
import '../models/api_response.dart';
import '../utils/api_response_utils.dart';

class PaymentRepository extends HttpService {

  Future<ApiResponse> createPaymentSheet(BuildContext context,String firstName,String email,double amount) async {
    //host = Api.basePaymentUrl;
    final apiResult = await post(Api.createPayment,{"first_name":firstName,"last_name":firstName,"email":email,"amount":amount});

    ApiResponse apiResponse = await ApiResponseUtils.parseApiResponse(apiResult,context);

    print(apiResponse..body);
    return apiResponse;
  }
}


/*import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import '../constants/api.dart';
import '../services/http.service.dart';
import '../models/api_response.dart';
import '../utils/api_response_utils.dart';

class PaymentRepository extends HttpService {
  Future<String?> createPaymentSheet(
      BuildContext context,
      String firstName,
      String email,
      double amount,
      ) async {
    final apiResult = await post(Api.createPayment, {
      "first_name": firstName,
      "last_name": firstName, // Usando lo stesso nome per last_name
      "email": email,
      "amount": amount,
    });

    ApiResponse apiResponse = await ApiResponseUtils.parseApiResponse(apiResult, context);

    if (apiResponse.allGood && apiResponse.body != null) {
      return apiResponse.body["clientSecret"];
    }

    return null;
  }
  Future<Map<String, dynamic>> createPaymentIntent({
    required String firstName,
    required String lastName,
    required String email,
    required int amount,
  }) async {
    final response = await http.post(
      Uri.parse('https://your-api-url.com/api/payments/createPaymentIntent'),
      body: {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'amount': amount.toString(),
      },
    );

    if (response.statusCode == 200) {
      // Se la richiesta ha successo, ritorna i dati del Payment Intent
      return json.decode(response.body);
    } else {
      // In caso di errore, solleva un'eccezione
      throw Exception('Failed to create Payment Intent');
    }
  }
}
*/