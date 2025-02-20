import 'package:flutter/cupertino.dart';
import '../constants/api.dart';
import '../services/http.service.dart';
import '../models/api_response.dart';
import '../utils/api_response_utils.dart';

class WorkoutPlanDetailRepository extends HttpService {

  Future<ApiResponse> getWorkoutPlans(BuildContext context) async {
    final apiResult = await get(Api.getWorkoutPlans);
    ApiResponse apiResponse = await ApiResponseUtils.parseApiResponse(apiResult,context);
    return apiResponse;
  }
}