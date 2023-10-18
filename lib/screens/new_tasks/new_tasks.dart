import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../component/component.dart';
import '../../logic/to_do_cubit.dart';



class NewTask extends StatelessWidget {
  const NewTask({super.key});


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToDoCubit,ToDoState>(
     listener: (context, state) {},
      builder: (context, state) {
      var tasks= ToDoCubit.get(context).task;
      return  ListView.separated(
            itemBuilder: (context,index)=>itemTaskBuilder(tasks[index],context),
            separatorBuilder:(context,index)=>Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey[300],
            ),
            itemCount: tasks.length);
      },
    );
  }
}
