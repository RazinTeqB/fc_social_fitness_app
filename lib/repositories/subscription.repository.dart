import 'package:flutter/cupertino.dart';
import '../constants/api.dart';
import '../services/http.service.dart';
import '../models/api_response.dart';
import '../utils/api_response_utils.dart';

class SubscriptionRepository extends HttpService {

  Future<ApiResponse> getSubscriptions(BuildContext context) async {
    final apiResult = await get(Api.getSubscriptions);
    ApiResponse apiResponse = await ApiResponseUtils.parseApiResponse(apiResult,context);
    return apiResponse;
  }

  Future<ApiResponse> attachSubscription(BuildContext context, int subscriptionId) async {
    final data = {
      'subscription_id': subscriptionId,
    };
    final apiResult = await post(Api.attachSubscription, data);
    ApiResponse apiResponse = await ApiResponseUtils.parseApiResponse(apiResult, context);
    return apiResponse;
  }

  Future<ApiResponse> getUserSubscriptions(BuildContext context) async {
    final apiResult = await get(Api.getUserSubscriptions);  // Usa il metodo get della tua HttpService
    ApiResponse apiResponse = await ApiResponseUtils.parseApiResponse(apiResult, context);
    return apiResponse;
  }
}