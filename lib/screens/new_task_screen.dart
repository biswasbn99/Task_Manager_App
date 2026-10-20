import 'package:flutter/material.dart';
import 'package:task_manager_app/data/model/api_response.dart';
import 'package:task_manager_app/data/model/task_model.dart';
import 'package:task_manager_app/data/model/task_status_count_model.dart';
import 'package:task_manager_app/data/service/api_caller.dart';
import 'package:task_manager_app/screens/add_new_task_screen.dart';
import 'package:task_manager_app/utils/urls.dart';
import 'package:task_manager_app/widgets/task_card.dart';
import 'package:task_manager_app/widgets/task_count_by_status.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  @override
  void initState() {
    super.initState();
    getAllTaskCount();
    getAllNewTask();
  }

  List<TaskStatusCountModel> taskCountByStatus = [];
  List<TaskModel> newTask = [];
  bool _inProgress = false;

  Future<void> getAllTaskCount() async {
    final ApiResponse response =
        await ApiCaller.getRequest(URL: Urls.getTaskCountURL);

    List<TaskStatusCountModel> taskCount = [];

    if (response.isSuccess && response.responseData?['data'] != null) {
      for (Map<String, dynamic> jsonData in response.responseData['data']) {
        taskCount.add(TaskStatusCountModel.fromJson(jsonData));
      }
    } else {
      final String errorMsg = response.errorMessage ??
          response.responseData?['data']?.toString() ??
          response.responseData?['message']?.toString() ??
          'Failed to load task count';

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMsg)),
        );
      }
    }

    if (mounted) {
      setState(() {
        taskCountByStatus = taskCount;
      });
    }
  }

  Future<void> getAllNewTask() async {
    setState(() {
      _inProgress = true;
    });

    final ApiResponse response =
        await ApiCaller.getRequest(URL: Urls.taskByStatusURL('New'));

    List<TaskModel> task = [];

    if (response.isSuccess && response.responseData?['data'] != null) {
      for (Map<String, dynamic> jsonData in response.responseData['data']) {
        task.add(TaskModel.fromJson(jsonData));
      }
    } else {
      final String errorMsg = response.errorMessage ??
          response.responseData?['data']?.toString() ??
          response.responseData?['message']?.toString() ??
          'Failed to load new tasks';

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMsg)),
        );
      }
    }

    if (mounted) {
      setState(() {
        newTask = task;
        _inProgress = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await getAllTaskCount();
          await getAllNewTask();
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 90,
                child: ListView.separated(
                  itemCount: taskCountByStatus.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return TaskCountByStatus(
                      title: taskCountByStatus[index].sId?.toString() ?? '',
                      count: taskCountByStatus[index].sum ?? 0,
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(width: 20);
                  },
                ),
              ),
            ),
            Expanded(
              child: Visibility(
                visible: !_inProgress,
                replacement: const Center(
                  child: CircularProgressIndicator(),
                ),
                child: newTask.isEmpty
                    ? const Center(
                        child: Text(
                          'No new tasks found',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        itemCount: newTask.length,
                        itemBuilder: (context, index) {
                          return TaskCard(
                            taskModel: newTask[index],
                            cardColor: Colors.blue,
                            refreshParent: () {
                              getAllTaskCount();
                              getAllNewTask();
                            },
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Listen for true return value to auto-reload
          final bool? result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddNewTaskScreen()),
          );
          if (result == true) {
            getAllTaskCount();
            getAllNewTask();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
