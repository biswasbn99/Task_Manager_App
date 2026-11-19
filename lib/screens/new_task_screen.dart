import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/providers/task_provider.dart';
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      _refreshData();
    });
    
  }
  void _refreshData(){
      context.read<TaskProvider>().getTaskStatusCount();
      context.read<TaskProvider>().getTasksByStatus('New');
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          _refreshData();
        },
        child: Column(
          children: [
            Consumer<TaskProvider>(
              builder: (context,taskProvider,_) {
                if(taskProvider.isCountLoading){
                  return SizedBox(
                    height: 90,
                    child: Center(child: CircularProgressIndicator(),),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 90,
                    child: ListView.separated(
                      itemCount: taskProvider.taskStatusCountList.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final countItem=taskProvider.taskStatusCountList[index];
                        return TaskCountByStatus(
                          title: countItem.sId?.toString() ?? '',
                          count: countItem.sum ?? 0,
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(width: 20);
                      },
                    ),
                  ),
                );
              }
            ),
           
           Expanded(
             child: Consumer<TaskProvider>(
               builder: (context,taskProvider,_) {
                if(taskProvider.isTaskLoading){
                  return const Center(child:CircularProgressIndicator());
                }
                if(taskProvider.newTaskList.isEmpty){
                  return const Center(
                    child: Text('No new tasks found',style: TextStyle(color: Colors.grey,fontSize:16),),
                  );
                }
                 return ListView.builder(
                  itemCount:taskProvider.newTaskList.length ,
                  
                  itemBuilder: (context,index){
                  return TaskCard(taskModel: taskProvider.newTaskList[index], cardColor: Colors.blue, refreshParent: _refreshData);
                  });
               }
             ),
           )
            
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
         final bool? result=await Navigator.push(context,MaterialPageRoute(builder: (context)=>AddNewTaskScreen()));
         if(result==true){
          _refreshData();
         }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
