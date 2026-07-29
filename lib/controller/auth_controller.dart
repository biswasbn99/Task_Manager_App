import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager_app/data/model/user_model.dart';

class AuthController {

  // For Saving user data locally
static String? accessToken;
static UserModel? userData;


  static Future saveUserData(UserModel model, String token)async{
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
 await sharedPreferences.setString('token', token);
 await sharedPreferences.setString('user-data', jsonEncode(model.toJson()));
 
 accessToken=token;
 userData=model;
  }

  // For getting user data from local storage
  static Future<bool> isUserLoggIn()async{
   SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
   String? token=sharedPreferences.getString('token');
   return token !=null;
  }
}