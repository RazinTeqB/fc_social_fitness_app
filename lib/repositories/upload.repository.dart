import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../constants/api.dart';
import '../services/http.service.dart';
import '../models/api_response.dart';
import '../utils/api_response_utils.dart';

class UploadRepository extends HttpService {
  //process user account login

  Future<ApiResponse> uploadFile(String folderName,File file) async {
    //instance of the model to be returned
    final apiResult = await postWithFiles(Api.storeTweetImage, {
      "folderName":folderName,
      "image": await MultipartFile.fromFile(
        file.path,
      )
    });
    ApiResponse apiResponse =
        await ApiResponseUtils.parseApiResponse(apiResult, null);
    return apiResponse;
  }
}
