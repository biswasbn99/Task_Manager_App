import 'package:flutter/foundation.dart';
import 'package:task_manager_app/data/model/api_response.dart';
import 'package:task_manager_app/data/model/task_model.dart';
import 'package:task_manager_app/data/model/task_status_count_model.dart';
import 'package:task_manager_app/data/service/api_caller.dart';
import 'package:task_manager_app/utils/urls.dart';

class TaskProvider extends ChangeNotifier{

  //Lists for 4 task types & Status count

  List<TaskModel>_newTaskList=[];
  List<TaskModel> _progressTaskList=[];
  List<TaskModel> _completedTaskList=[];
  List<TaskModel> _cancelledTaskList=[];
  List<TaskStatusCountModel> _taskStatusCountList=[];

  //Separate Loading Flags
  bool _isTaskLoading=false;
  bool _isCountLoading=false;
  bool _isCreateTaskLoading=false;
  String? _errorMessage;

  //Getters
  List<TaskModel> get newTaskList=> _newTaskList;
  List<TaskModel> get progressTaskList=> _progressTaskList;
  List<TaskModel> get completedTaskList=> _completedTaskList;
  List<TaskModel> get cancelledTaskList=> _cancelledTaskList;
  List<TaskStatusCountModel> get taskStatusCountList=> _taskStatusCountList;

  bool get isTaskLoading=>_isTaskLoading;
  bool get isCountLoading=>_isCountLoading;
  bool get isCreateTaskLoading=>_isCreateTaskLoading;
  String? get errorMessage=> _errorMessage;

  //New, Progress, Completed, Cancelled
  Future<bool> getTasksByStatus(String status)async{
    bool isSuccess=false;
    _isTaskLoading=true;
    notifyListeners();

    final ApiResponse response=await ApiCaller.getRequest(URL: Urls.taskByStatusURL(status));

    if(response.isSuccess && response.responseData?['data']!=null){
      List<TaskModel> tempList=[];
      for(Map<String, dynamic> jsonData in response.responseData['data']){
        tempList.add(TaskModel.fromJson(jsonData));
      }

      if(status == 'New'){
        _newTaskList=tempList;
      }else if(status=='Progress'){
        _progressTaskList=tempList;
      }else if(status=='Completed'){
          _completedTaskList=tempList;
        }else if(status == 'Cancelled'){
          _cancelledTaskList=tempList;
        }
        isSuccess=true;
        _errorMessage=null;
    }else{
      _errorMessage=response.errorMessage?? response.responseData?['data']?.toString()??'Failed to load $status tasks';
    }
    _isTaskLoading=false;
    notifyListeners();
    return isSuccess;
  }

  //Top Summary count Cards
  Future<bool> getTaskStatusCount()async{
    bool isSuccess=false;
    _isCountLoading=true;
    notifyListeners();

    final ApiResponse response=await ApiCaller.getRequest(URL: Urls.getTaskCountURL);
    if(response.isSuccess && response.responseData?['data']!=null){
      List<TaskStatusCountModel> tempCountList=[];
      for(Map<String, dynamic>jsonData in response.responseData['data']){
        tempCountList.add(TaskStatusCountModel.fromJson(jsonData));
      }
      _taskStatusCountList=tempCountList;
      isSuccess=true;
      _errorMessage=null;
    }else{
      _errorMessage=response.errorMessage??response.responseData?['data']?.toString()??'Failed to load task count';
    }
    _isCountLoading=false;
    notifyListeners();
    return isSuccess;
  }

//Add New Task
Future<bool> createNewTask({
required String title,
required String description,

})async{
  bool isSuccess=false;
  _isCreateTaskLoading=true;
  notifyListeners();

  Map<String, dynamic> requestBody={
    "title":title.trim(),
    "description":description.trim(),
    "status":"New",
  };

  final ApiResponse response=await ApiCaller.postRequest(URL: Urls.createTaskURL,body: requestBody);
  if(response.isSuccess){
    isSuccess=true;
    _errorMessage=null;
    await getTasksByStatus('New');
    await getTaskStatusCount();
  }else{
    _errorMessage=response.errorMessage?? response.responseData?['data']?.toString()??'Failed to create task';
  }

  _isCreateTaskLoading=false;
  notifyListeners();
  return isSuccess;
}

//Change Task Status
Future<bool> updateTaskStatus({
  required String taskId,
  required String newStatus,
  required String currentStatus,
})async{
  final ApiResponse response=await ApiCaller.getRequest(URL: Urls.taskStatusUpdateURL(taskId, newStatus));
  if(response.isSuccess){
    await getTasksByStatus(currentStatus);
    await getTasksByStatus(newStatus);
    await getTaskStatusCount();
    return true;
  }else{
    _errorMessage=response.errorMessage??response.responseData?['data']?.toString()??'Failed to update status';
    return false;
  }
}

//Delete Task
Future<bool> deleteTask({
  required String taskId,
  required String currentStatus,
})async{
  final ApiResponse response=await ApiCaller.getRequest(URL: Urls.taskDeleteURL(taskId));
  if(response.isSuccess){
    await getTasksByStatus(currentStatus);
    await getTaskStatusCount();
    return true;
  }else{
    _errorMessage=response.errorMessage?? response.responseData?['data']?.toString()??'Failed to delete task';
    return false;
  }
}
}