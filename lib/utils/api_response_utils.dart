import 'package:fc_social_fitness/utils/shared_manager.dart';
import 'package:flutter/cupertino.dart';


import '../constants/app_routes.dart';
import '../constants/app_strings.dart';
import 'app_database.dart';
import '../models/api_response.dart';

class ApiResponseUtils  {
  static Future<ApiResponse> parseApiResponse(dynamic response,BuildContext? context) async {

    int code = response.statusCode;
    dynamic body = response.data; // Would mostly be a Map
    List errors = [];
    String message = "";
    String errorMessage ="";
    switch (code) {
      case 200:
        try {
          if(body is Map<dynamic, dynamic> ) {
            if (body["data"]!=null) {
              if (body["data"]["message"] != null) {
                message = body["data"]["message"];
              } else {
                message = "";
              }
            } else {
              message = "";
            }
          }else{
            message = "";
          }
          //message = body is Map<dynamic, dynamic> ? body["data"]["message"]?? "" : "";
        } catch (error) {
          rethrow;
        }
        break;
      case 401:
        message = "Non autorizzato";
        errors.add("Sessione scaduta. Rifai il login!");
        if(SharedManager.authenticated())
        {
          if(context!=null)
            {
              Navigator.pushNamed(context,AppRoutes.loginRoute);
            }
          SharedManager.setBool(AppStrings.authenticated, false);
          await AppDatabase.deleteCurrentUser();
        }
        break;
      default:

        break;
    }

    if(body['data']!=null)
      {
        return ApiResponse(
          code: code,
          message: message,
          body: body['data'],
          errors: errors,
          errorMessage:errorMessage,
        );
      }else{
      return ApiResponse(
        code: code,
        message: message,
        body: body,
        errors: errors,
        errorMessage:errorMessage,
      );
    }
  }
}
