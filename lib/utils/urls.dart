class Urls {
  static const String _baseURL = 'https://task-manager-api.ostad.live/api/v1';
  static const String signUpURL = '$_baseURL/Registration';
  static const String signInURL = '$_baseURL/Login';
  static const String updateProfileURL = '$_baseURL/ProfileUpdate';
  static const String getTaskCountURL = '$_baseURL/taskStatusCount';
  static const String createTaskURL = '$_baseURL/createTask';
  static String taskByStatusURL(String status) =>
      '$_baseURL/listTaskByStatus/$status';
  static String taskDeleteURL(String id) => '$_baseURL/deleteTask/$id';
  static String taskStatusUpdateURL(String taskID, String status) =>
      '$_baseURL/updateTaskStatus/$taskID/$status';

  // Forget Password Endpoints
  static String recoverVerifyEmailURL(String email) =>
      '$_baseURL/RecoverVerifyEmail/$email';
  static String recoverVerifyOtpURL(String email, String otp) =>
      '$_baseURL/RecoverVerifyOtp/$email/$otp';
  static const String recoverResetPasswordURL =
      '$_baseURL/RecoverResetPassword';
}
