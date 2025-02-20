import 'package:flutter/cupertino.dart';
import '../constants/api.dart';
import '../services/http.service.dart';
import '../models/api_response.dart';
import '../utils/api_response_utils.dart';

class AuthRepository extends HttpService {
  //FirebaseMessaging instance
  //FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  //process user account login
  Future<ApiResponse> login(BuildContext context,
      {required String email, required String password}) async {
    //instance of the model to be returned
    final apiResult = await post(
      Api.login,
      {
        "email": email,
        "password": password,
      },
    );
    ApiResponse apiResponse =
        await ApiResponseUtils.parseApiResponse(apiResult, context);
    return apiResponse;
  }

  //process user account login
  Future<ApiResponse> loginWithSocial(BuildContext context,
      {required String social_token}) async {
    //instance of the model to be returned
    final apiResult = await post(
      Api.loginWithSocial,
      {
        "social_token": social_token,
      },
    );
    ApiResponse apiResponse =
        await ApiResponseUtils.parseApiResponse(apiResult, context);
    return apiResponse;
  }

  Future<ApiResponse> updateUser(
      BuildContext? context, Map<String, dynamic> input) async {
    final apiResult = await put(Api.updateUser, input);
    ApiResponse apiResponse =
        await ApiResponseUtils.parseApiResponse(apiResult, context);
    return apiResponse;
  }
  Future<ApiResponse> updateUserData(
      BuildContext? context, Map<String, dynamic> input) async {
    final apiResult = await put(Api.updateUserData, input);
    ApiResponse apiResponse =
    await ApiResponseUtils.parseApiResponse(apiResult, context);
    return apiResponse;
  }

  Future<ApiResponse> signup(BuildContext context,
      {required String email,
      required String password,
      required String username,
      required phone,
      required name,
      required gender,
      required String bio,
      required dateBorn,
      required height,
      required weight,
      String? firebaseToken}) async {
    //instance of the model to be returned
    if(bio.isEmpty)
      {
        bio = " ";
      }
    final apiResult = await post(
      Api.signup,
      {
        "email": email,
        "password": password,
        "username": username,
        "social_token": firebaseToken,
        "phone": phone,
        "name": name,
        "gender": gender,
        "bio": bio,
        "date_born": dateBorn,
        "height": height,
        "weight": weight,
      },
    );
    ApiResponse apiResponse =
        await ApiResponseUtils.parseApiResponse(apiResult, context);
    return apiResponse;
  }

  Future<ApiResponse> checkPhone(BuildContext context,
      {required String phone}) async {
    //instance of the model to be returned
    final apiResult = await post(
      Api.checkPhone,
      {
        "phone": phone,
      },
    );
    ApiResponse apiResponse =
        await ApiResponseUtils.parseApiResponse(apiResult, context);
    return apiResponse;
  }

  Future<ApiResponse> checkEmailUsername(BuildContext context,
      {required String username, required String email}) async {
    //instance of the model to be returned
    final apiResult = await post(
      Api.checkEmailUsername,
      {
        "username": username,
        "email": email,
      },
    );
    ApiResponse apiResponse =
        await ApiResponseUtils.parseApiResponse(apiResult, context);
    return apiResponse;
  }

}
