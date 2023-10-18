import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../component/component.dart';
import '../../logic/to_do_cubit.dart';


class Archive extends StatelessWidget {
  const Archive({super.key});

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<ToDoCubit,ToDoState>(
      listener: (context, state) {},
      builder: (context, state) {
        var task=ToDoCubit.get(context).archiveTask;
        return conditionalBuild(task: task);
      //
      },
    );
  }
}
