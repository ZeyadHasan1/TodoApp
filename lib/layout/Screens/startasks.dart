import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/Cubit/bloc.dart';
import 'package:todo/Cubit/states.dart';
import 'package:todo/components/compo.dart';

class ArchivedTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = AppCubit.get(context).archivedTasks;

        return tasksBuilder(
          tasks: tasks,
          circle: Icons.circle_outlined,
          important: Icons.star,
          isDone: Colors.pink,
          isImportant: Colors.grey,
        );
      },
    );
  }
}
