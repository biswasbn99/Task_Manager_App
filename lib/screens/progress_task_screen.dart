import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/providers/task_provider.dart';
import 'package:task_manager_app/widgets/task_card.dart';

class ProgressTaskScreen extends StatefulWidget {
  const ProgressTaskScreen({super.key});

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshData();
    });
  }

  void _refreshData() {
    context.read<TaskProvider>().getTasksByStatus('Progress');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, _) {
          if (taskProvider.isTaskLoading) {
            return Center(child: CircularProgressIndicator());
          }
          return RefreshIndicator(
            onRefresh: () async {
              _refreshData();
            },
            child: taskProvider.progressTaskList.isEmpty
                ? Center(
                    child: Text(
                      'No Progress tasks found',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: taskProvider.progressTaskList.length,
                    itemBuilder: (context, index) {
                      return TaskCard(
                        taskModel: taskProvider.progressTaskList[index],
                        cardColor: Colors.purple,
                        refreshParent: _refreshData,
                      );
                    },
                  ),
          );
        },
      ),
    );
  }
}
