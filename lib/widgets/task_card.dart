import 'package:flutter/material.dart';
import 'package:task_manager_app/data/model/api_response.dart';
import 'package:task_manager_app/data/model/task_model.dart';
import 'package:task_manager_app/data/service/api_caller.dart';
import 'package:task_manager_app/utils/app_color.dart';
import 'package:task_manager_app/utils/urls.dart';

class TaskCard extends StatefulWidget {
  final TaskModel taskModel;
  final Color cardColor;
  final VoidCallback refreshParent;
  const TaskCard({
    super.key,
    required this.taskModel,
    required this.cardColor,
    required this.refreshParent,
  });

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  Future<void> changeStatus(String status) async {
    final ApiResponse response = await ApiCaller.getRequest(
      URL: Urls.taskStatusUpdateURL(widget.taskModel.id, status),
    );

    setState(() {});
    if (response.isSuccess) {
      widget.refreshParent();
      Navigator.pop(context);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Task Status Updated')));
    } else {
      Navigator.pop(context);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(response.responseData['data'])));
    }

    print(response.responseData);
  }

  Future<void> deleteTask() async {
    final ApiResponse response = await ApiCaller.getRequest(
      URL: Urls.taskDeleteURL(widget.taskModel.id),
    );

    setState(() {});
    if (response.isSuccess) {
      widget.refreshParent();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Task Deleted')));
    } else {
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(response.responseData['data'])));
    }

    print(response.responseData);
  }

  void showChangeStatusDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Change Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Card(
              color: widget.taskModel.status == 'New' ? Colors.green : null,
              child: ListTile(
                title: Text('New'),
                onTap: () {
                  changeStatus('New');
                },
                trailing: widget.taskModel.status == 'New'
                    ? Icon(Icons.check_circle, color: Colors.white)
                    : null,
              ),
            ),

            Card(
              color: widget.taskModel.status == 'Progress'
                  ? Colors.green
                  : null,
              child: ListTile(
                title: Text('Progress'),
                onTap: () {
                  changeStatus('Progress');
                },
                trailing: widget.taskModel.status == 'Progress'
                    ? Icon(Icons.check_circle, color: Colors.white)
                    : null,
              ),
            ),

            Card(
              color: widget.taskModel.status == 'Completed'
                  ? Colors.green
                  : null,
              child: ListTile(
                title: Text('Completed'),
                onTap: () {
                  changeStatus('Completed');
                },
                trailing: widget.taskModel.status == 'Completed'
                    ? Icon(Icons.check_circle, color: Colors.white)
                    : null,
              ),
            ),

            Card(
              color: widget.taskModel.status == 'Cancelled' ? Colors.green : null,
              child: ListTile(
                title: Text('Cancelled'),
                onTap: () {
                  changeStatus('Cancelled');
                },
                trailing: widget.taskModel.status == 'Cancelled'
                    ? Icon(Icons.check_circle, color: Colors.white)
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Colors.white,
        child: ListTile(
          title: Text(
            widget.taskModel.title,
            style: Theme.of(
              context,
            ).textTheme.titleLarge!.copyWith(fontSize: 20),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Text(
                widget.taskModel.description,
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),

              SizedBox(height: 8),
              Text(
                'Date:${widget.taskModel.createdDate}',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 15),

              Row(
                children: [
                  Chip(
                    label: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        widget.taskModel.status,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(25),
                    ),

                    backgroundColor: widget.cardColor,
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () {
                      showChangeStatusDialog();
                    },
                    icon: Icon(Icons.edit_note_rounded, color: AppColor.Pcolor),
                  ),
                  IconButton(
                    onPressed: () {
                      deleteTask();
                    },
                    icon: Icon(Icons.delete, color: Colors.red),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
