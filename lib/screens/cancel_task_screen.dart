import 'package:flutter/material.dart';
import 'package:task_manager_app/data/model/task_model.dart';
import 'package:task_manager_app/widgets/task_card.dart';

class CancelTaskScreen extends StatefulWidget {
  const CancelTaskScreen({super.key});

  @override
  State<CancelTaskScreen> createState() => _CancelTaskScreenState();
}

class _CancelTaskScreenState extends State<CancelTaskScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return TaskCard(
                  taskModel: TaskModel(
                    id: '50',
                    title: 'demo task title',
                    description: 'Demo task Description',
                    status: 'Cancel',
                    email: '',
                    createdDate: '15-07-2026',
                  ),
                  cardColor: Colors.red,
                  refreshParent: () {},
                );
              },
            ),
    );
  }
}