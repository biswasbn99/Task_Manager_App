import 'package:flutter/material.dart';
import 'package:task_manager_app/data/model/api_response.dart';
import 'package:task_manager_app/data/model/task_model.dart';
import 'package:task_manager_app/data/service/api_caller.dart';
import 'package:task_manager_app/utils/urls.dart';
import 'package:task_manager_app/widgets/task_card.dart';

class ProgressTaskScreen extends StatefulWidget {
  const ProgressTaskScreen({super.key});

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {
  bool _inProgress = false;
  List<TaskModel> allTask = [];

  @override
  void initState() {
    super.initState();
    getAllTask();
  }

  Future<void> getAllTask() async {
    setState(() {
      _inProgress = true;
    });

    final ApiResponse response =
        await ApiCaller.getRequest(URL: Urls.taskByStatusURL('Progress'));

    List<TaskModel> task = [];

    if (response.isSuccess && response.responseData?['data'] != null) {
      for (Map<String, dynamic> jsonData in response.responseData['data']) {
        task.add(TaskModel.fromJson(jsonData));
      }
    } else {
      final String errorMsg = response.errorMessage ??
          response.responseData?['data']?.toString() ??
          response.responseData?['message']?.toString() ??
          'Failed to load progress tasks';

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMsg)),
        );
      }
    }

    if (mounted) {
      setState(() {
        allTask = task;
        _inProgress = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Visibility(
        visible: !_inProgress,
        replacement: const Center(
          child: CircularProgressIndicator(),
        ),
        child: RefreshIndicator(
          onRefresh: getAllTask,
          child: allTask.isEmpty
              ? const Center(
                  child: Text(
                    'No progress tasks found',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                )
              : ListView.builder(
                  itemCount: allTask.length,
                  itemBuilder: (context, index) {
                    return TaskCard(
                      taskModel: allTask[index],
                      cardColor: Colors.purple,
                      refreshParent: () {
                        getAllTask();
                      },
                    );
                  },
                ),
        ),
      ),
    );
  }
}
