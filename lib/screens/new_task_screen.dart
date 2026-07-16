import 'package:flutter/material.dart';
import 'package:task_manager_app/data/model/task_model.dart';
import 'package:task_manager_app/screens/add_new_task_screen.dart';
import 'package:task_manager_app/widgets/task_card.dart';
import 'package:task_manager_app/widgets/task_count_by_status.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 90,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return TaskCountByStatus(title: 'New', count: 5);
                },
                separatorBuilder: (context, index) {
                  return SizedBox(width: 20);
                },
                itemCount: 4,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return TaskCard(
                  taskModel: TaskModel(
                    id: '50',
                    title: 'demo task title',
                    description: 'Demo task Description',
                    status: 'New',
                    email: '',
                    createdDate: '15-07-2026',
                  ),
                  cardColor: Colors.blue,
                  refreshParent: () {},
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNewTaskScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
