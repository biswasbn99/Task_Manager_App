import 'dart:convert';

import 'package:logger/web.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager_app/data/model/user_model.dart';

class AuthController {

  // For Saving user data locally
static String? accessToken;
static UserModel? userData;
static final Logger _logger=Logger();


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

// For getting user data from local storage
  static Future getUserData() async{
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    String? token =sharedPreferences.getString('token');

    if(token!=null){
      accessToken=token;
    }
    String? user=sharedPreferences.getString('user-data');
    if(user !=null && user.isNotEmpty){
      userData=UserModel.fromJson(jsonDecode(user));
    }
 _logger.i(accessToken);
 _logger.i(userData);
    
  }
}