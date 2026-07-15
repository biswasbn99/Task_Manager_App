import 'package:flutter/material.dart';
import 'package:task_manager_app/data/model/task_model.dart';
import 'package:task_manager_app/widgets/task_card.dart';

class ProgressTaskScreen extends StatefulWidget {
  const ProgressTaskScreen({super.key});

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {
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
                    status: 'Progress',
                    email: '',
                    createdDate: '15-07-2026',
                  ),
                  cardColor: Colors.purple,
                  refreshParent: () {},
                );
              },
            ),
    );
  }
}