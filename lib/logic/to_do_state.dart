part of 'to_do_cubit.dart';

abstract class ToDoState {}

class ToDoInitial extends ToDoState {}

class AppChangeIndexState extends ToDoState {}

class AppLoadingDBState extends ToDoState {}

class AppGetDBState extends ToDoState {}


class AppCreateDBState extends ToDoState {}

class AppInsertDBState extends ToDoState {}

class AppUpdateDBState extends ToDoState {}

class AppDeleteDBState extends ToDoState {}

class AppChangeBottomShow extends ToDoState {}
