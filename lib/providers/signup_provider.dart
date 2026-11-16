import 'package:flutter/foundation.dart';
import 'package:task_manager_app/data/model/api_response.dart';
import 'package:task_manager_app/data/service/api_caller.dart';
import 'package:task_manager_app/utils/urls.dart';
class SignUpProvider extends ChangeNotifier{
  bool _isSignUpInProgress =false;
  String? _errorMessage;

  bool get isSignUpInProgress=> _isSignUpInProgress;
  String? get errorMessage=>_errorMessage;

Future<bool> registerUser({required String email,
  required String firstName,
  required String lastName,
  required String mobile,
  required String password,

})async{
 bool isSuccess=false;
 _isSignUpInProgress=true;
 notifyListeners();
 Map<String, dynamic> requestBody={
  "email":email,
  "firstName":firstName,
  "lastName":lastName,
  "mobile":mobile,
  "password":password
 };

 final ApiResponse response =await ApiCaller.postRequest(URL: Urls.signUpURL,body: requestBody);

if(response.isSuccess){
  isSuccess=true;
  _errorMessage=null;
}else{
  _errorMessage=response.errorMessage??response.responseData?['data']?.toString()??'Registration failed. please try again';
}

_isSignUpInProgress=false;
notifyListeners();
return isSuccess;
}
  
}