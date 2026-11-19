import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/providers/task_provider.dart';
import 'package:task_manager_app/widgets/task_card.dart';

class CancelTaskScreen extends StatefulWidget {
  const CancelTaskScreen({super.key});

  @override
  State<CancelTaskScreen> createState() => _CancelTaskScreenState();
}

class _CancelTaskScreenState extends State<CancelTaskScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshData();
    });
  }

  void _refreshData() {
    context.read<TaskProvider>().getTasksByStatus('Cancelled');
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
            child: taskProvider.cancelledTaskList.isEmpty
                ? Center(
                    child: Text(
                      'No cancelled tasks found',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: taskProvider.cancelledTaskList.length,
                    itemBuilder: (context, index) {
                      return TaskCard(
                        taskModel: taskProvider.cancelledTaskList[index],
                        cardColor: Colors.red,
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
