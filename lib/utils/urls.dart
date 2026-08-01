class Urls {
  static String _baseURL = 'https://task-manager-api.ostad.live/api/v1';
  static String signUpURL='$_baseURL/Registration';
  static String signInURL='$_baseURL/Login';
  static String getTaskCountURL='$_baseURL/taskStatusCount';
  static String createTaskURL='$_baseURL/createTask';
  static String taskByStatusURL(String status)=>'$_baseURL/listTaskByStatus/$status';
}