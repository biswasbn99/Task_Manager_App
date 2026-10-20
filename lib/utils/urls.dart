class Urls {
  static String _baseURL = 'https://task-manager-api.ostad.live/api/v1';
  static String signUpURL='$_baseURL/Registration';
  static String signInURL='$_baseURL/Login';
  static String updateProfileURL='$_baseURL/ProfileUpdate';
  static String getTaskCountURL='$_baseURL/taskStatusCount';
  static String createTaskURL='$_baseURL/createTask';
  static String taskByStatusURL(String status)=>'$_baseURL/listTaskByStatus/$status';
  static String taskDeleteURL(String id)=> '$_baseURL/deleteTask/$id';
  static String taskStatusUpdateURL(String taskID, String status)=>'$_baseURL/updateTaskStatus/$taskID/$status';
}