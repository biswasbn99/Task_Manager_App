import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/providers/task_provider.dart';
import 'package:task_manager_app/widgets/screen_background.dart';
import 'package:task_manager_app/widgets/task_manager_appbar.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  Future<void> _onTapCreateTask() async {
    if (_formKey.currentState!.validate()) {
      final taskProvider = context.read<TaskProvider>();
      final bool isSuccess = await taskProvider.createNewTask(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
      );

      if (!mounted) return;

      if (isSuccess) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('New Task Successfully Created')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(taskProvider.errorMessage ?? 'Failed to create task'),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TaskManagerAppBar(),
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Text(
                    'Add New Task',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 25),
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(hintText: 'Title'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 25),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 6,
                    decoration: const InputDecoration(hintText: 'Description'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 25),
                  Consumer<TaskProvider>(
                    builder: (context, taskProvider, _) {
                      return Visibility(
                        visible: !taskProvider.isCreateTaskLoading,
                        replacement: const Center(
                          child: CircularProgressIndicator(),
                        ),
                        child: FilledButton(
                          onPressed: _onTapCreateTask,
                          child: const Icon(Icons.arrow_circle_right_outlined),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
