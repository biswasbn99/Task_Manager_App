import 'package:flutter/material.dart';

class TaskCountByStatus extends StatelessWidget {
  final String title;
  final int count;
  const TaskCountByStatus({super.key, required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: 79,
      
      decoration: BoxDecoration(
       color: Colors.white,
       borderRadius: BorderRadius.circular(10),
       boxShadow: [
      BoxShadow(
        color: Colors.grey.shade200,
        blurRadius: 5,
        offset: Offset(2, 5)
      )
       ]
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          children: [
            Text(count.toString(), style: Theme.of(context).textTheme.titleLarge),
            Text(title),
          ],
        ),
      ),
    );
  }
}
