import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/logic/to_do_cubit.dart';
import '../component/component.dart';
import 'package:intl/intl.dart';

class LayoutScreen extends StatelessWidget {
  LayoutScreen({super.key});


  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var statusController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();


  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context) => ToDoCubit()..createDB(),
      child: BlocConsumer<ToDoCubit, ToDoState>(
        listener: (context, state) {
          if (state is AppInsertDBState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          ToDoCubit cubit = ToDoCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.title[cubit.currentIndex]),
            ),
            body: ConditionalBuilder(
              condition: state is! AppLoadingDBState,
              builder: (context) => cubit.screens[cubit.currentIndex],
              fallback: ((context) =>
                  const Center(child: CircularProgressIndicator())),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              elevation: 0,
              onTap: (index) {
                cubit.changeIndex(index);
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.task),
                  label: 'tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.done_all_outlined),
                  label: 'done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive),
                  label: 'archive',
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.showBottom) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertIntoDB(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text,
                        state: statusController.text);
                    cubit.changeBottomShow(isShow: false, icon: Icons.edit);
                  }
                } else {
                  scaffoldKey.currentState!
                      .showBottomSheet((context) => Padding(
                            padding: const EdgeInsets.all(20),
                            child: Form(
                              key: formKey,
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    defaultTextFormField(
                                        controller: titleController,
                                        labelText: 'title',
                                        type: TextInputType.text,
                                        prefixIcon: Icons.title,
                                        validate: (value) {
                                          if (value.isEmpty) {
                                            return ('title must not empty');
                                          }
                                        }),
                                    const SizedBox(height: 15),
                                    defaultTextFormField(
                                        controller: statusController,
                                        labelText: 'Status',
                                        type: TextInputType.text,
                                        prefixIcon: Icons.baby_changing_station,
                                        validate: (value) {
                                          if (value.isEmpty) {
                                            return ('Status must not empty');
                                          }
                                        }),
                                    const SizedBox(height: 15),
                                    defaultTextFormField(
                                        controller: timeController,
                                        labelText: 'time',
                                        type: TextInputType.text,
                                        prefixIcon: Icons.watch_later_outlined,
                                        validate: (value) {
                                          if (value.isEmpty) {
                                            return ('time must not empty');
                                          }
                                        },
                                        onTap: () {
                                          showTimePicker(
                                                  context: context,
                                                  initialTime: TimeOfDay.now())
                                              .then((value) {
                                            timeController.text =
                                                value!.format(context);
                                          });
                                        }),
                                    const SizedBox(height: 15),
                                    defaultTextFormField(
                                        controller: dateController,
                                        labelText: 'date',
                                        type: TextInputType.text,
                                        prefixIcon: Icons.date_range_outlined,
                                        validate: (value) {
                                          if (value.isEmpty) {
                                            return ('date must not empty');
                                          }
                                        },
                                        onTap: () {
                                          showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime.now(),
                                                  lastDate: DateTime.parse(
                                                      '2028-05-03'))
                                              .then((value) {
                                            dateController.text =
                                                DateFormat.yMMMd()
                                                    .format(value!);
                                          });
                                        }),
                                  ],
                                ),
                              ),
                            ),
                          ))
                      .closed
                      .then((value) {
                    cubit.changeBottomShow(isShow: false, icon: Icons.edit);
                  });
                  cubit.changeBottomShow(isShow: true, icon: Icons.add);
                }
              },
              child: Icon(cubit.fabIcon),
            ),
          );
        },
      ),
    );
  }
}
