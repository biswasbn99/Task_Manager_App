import 'package:flutter/foundation.dart';
import 'package:task_manager_app/controller/auth_controller.dart';
import 'package:task_manager_app/data/model/api_response.dart';
import 'package:task_manager_app/data/model/user_model.dart';
import 'package:task_manager_app/data/service/api_caller.dart';
import 'package:task_manager_app/utils/urls.dart';

class LoginProvider extends ChangeNotifier {
  bool _isLoginInProgress = false;

  bool get isLoginInProgress => _isLoginInProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> signIn(String email, String password) async {
    bool isSuccess = false;

    _isLoginInProgress = true;
    notifyListeners();

    Map<String, dynamic> requestBody = {"email": email, "password": password};

    final ApiResponse response = await ApiCaller.postRequest(
      URL: Urls.signInURL,
      body: requestBody,
    );

    if (response.isSuccess) {
      UserModel model = UserModel.fromJson(response.responseData['data']);
      String accessToken = response.responseData['token'];

      // Must await saving to SharedPreferences and static variables
      await AuthController.saveUserData(model, accessToken);

      isSuccess = true;
      _errorMessage = null;
    } else {
      _errorMessage = response.errorMessage;
    }
    _isLoginInProgress = false;
    notifyListeners();
    return isSuccess;
  }
}
