import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/Cubit/bloc.dart';
import 'package:todo/Cubit/states.dart';
import 'package:todo/components/compo.dart';

class DoneTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppCubit.get(context).createDatabase();
        var tasks = AppCubit.get(context).doneTasks;

        return tasksBuilder(
          tasks: tasks,
          circle: Icons.check_circle,
          isDone: Colors.grey,
          important: Icons.star_outline,
          isImportant: Colors.pink,
        );
      },
    );
  }
}
