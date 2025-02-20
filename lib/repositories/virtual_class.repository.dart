import 'package:flutter/cupertino.dart';
import '../constants/api.dart';
import '../services/http.service.dart';
import '../models/api_response.dart';
import '../utils/api_response_utils.dart';

class VirtualClassRepository extends HttpService {

  Future<ApiResponse> getAgoraToken(BuildContext context,String channelName,String uid) async {
    final apiResult = await get("/rtc/${channelName}/publisher/uid/${uid}");
    ApiResponse apiResponse = await ApiResponseUtils.parseApiResponse(apiResult,context);
    return apiResponse;
  }
}