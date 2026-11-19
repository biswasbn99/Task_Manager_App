import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/providers/task_provider.dart';
import 'package:task_manager_app/widgets/task_card.dart';

class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshData();
    });
  }

  void _refreshData() {
    context.read<TaskProvider>().getTasksByStatus('Completed');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<TaskProvider>(
        builder: (context, taskprovider, _) {
          if (taskprovider.isTaskLoading) {
            return Center(child: CircularProgressIndicator());
          }
          return RefreshIndicator(
            onRefresh: () async {
              _refreshData();
            },
            child: taskprovider.completedTaskList.isEmpty
                ? Center(
                    child: Text(
                      'No completed tasks found',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: taskprovider.completedTaskList.length,
                    itemBuilder: (context, index) {
                      return TaskCard(
                        taskModel: taskprovider.completedTaskList[index],
                        cardColor: Colors.green,
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
