import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:task_manager_app/app.dart';
import 'package:task_manager_app/controller/auth_controller.dart';
import 'package:task_manager_app/data/model/api_response.dart';
import 'package:task_manager_app/screens/login_screen.dart';

class ApiCaller {
  static final Logger _logger = Logger();

  static Future<ApiResponse> getRequest({required String URL}) async {
    try {
      _logger.i('GET: $URL');
      _logger.i('Token: ${AuthController.accessToken}');

      Response response = await get(
        Uri.parse(URL),
        headers: {'token': AuthController.accessToken ?? ''},
      );

      _logger.i(response.statusCode);
      _logger.i(response.body);

      final dynamic decodedBody = jsonDecode(response.body);

      if (response.statusCode == 401 ||
          (decodedBody is Map && decodedBody['status'] == 'unauthorized')) {
        await _handleUnauthorized();
        return ApiResponse(
          responseCode: response.statusCode,
          responseData: decodedBody,
          errorMessage: 'Session expired. Please log in again.',
          isSuccess: false,
        );
      }

      if (response.statusCode == 200 &&
          (decodedBody is! Map || decodedBody['status'] == 'success')) {
        return ApiResponse(
          responseCode: response.statusCode,
          responseData: decodedBody,
          isSuccess: true,
        );
      } else {
        return ApiResponse(
          responseCode: response.statusCode,
          responseData: decodedBody,
          errorMessage: _extractErrorMessage(decodedBody),
          isSuccess: false,
        );
      }
    } catch (e) {
      _logger.e(e);
      return ApiResponse(
        responseCode: -1,
        responseData: null,
        errorMessage: e.toString(),
        isSuccess: false,
      );
    }
  }

  static Future<ApiResponse> postRequest({
    required String URL,
    Map<String, dynamic>? body,
  }) async {
    try {
      _logger.i('POST: $URL');
      _logger.i('Token: ${AuthController.accessToken}');

      Response response = await post(
        Uri.parse(URL),
        headers: {
          "Content-type": "application/json",
          "Accept": "application/json",
          'token': AuthController.accessToken ?? '',
        },
        body: body != null ? jsonEncode(body) : null,
      );

      _logger.i(response.statusCode);
      _logger.i(response.body);

      final dynamic decodedBody = jsonDecode(response.body);

      if (response.statusCode == 401 ||
          (decodedBody is Map && decodedBody['status'] == 'unauthorized')) {
        await _handleUnauthorized();
        return ApiResponse(
          responseCode: response.statusCode,
          responseData: decodedBody,
          errorMessage: 'Session expired. Please log in again.',
          isSuccess: false,
        );
      }

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          (decodedBody is! Map || decodedBody['status'] == 'success')) {
        return ApiResponse(
          responseCode: response.statusCode,
          responseData: decodedBody,
          isSuccess: true,
        );
      } else {
        return ApiResponse(
          responseCode: response.statusCode,
          responseData: decodedBody,
          errorMessage: _extractErrorMessage(decodedBody),
          isSuccess: false,
        );
      }
    } catch (e) {
      _logger.e(e);
      return ApiResponse(
        responseCode: -1,
        responseData: null,
        errorMessage: e.toString(),
        isSuccess: false,
      );
    }
  }

  static Future<void> _handleUnauthorized() async {
    await AuthController.clearUserData();
    TaskManagerApp.navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  static String _extractErrorMessage(dynamic decodedBody) {
    if (decodedBody is Map) {
      return (decodedBody['data'] ??
              decodedBody['message'] ??
              'Something went wrong')
          .toString();
    }
    return decodedBody?.toString() ?? 'Something went wrong';
  }
}
