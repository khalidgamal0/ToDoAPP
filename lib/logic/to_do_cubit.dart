import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import '../screens/archive/archive.dart';
import '../screens/done/done.dart';
import '../screens/new_tasks/new_tasks.dart';
part 'to_do_state.dart';

class ToDoCubit extends Cubit<ToDoState> {
  ToDoCubit() : super(ToDoInitial());

  static ToDoCubit get(context) {
    return BlocProvider.of(context);
  }
  int currentIndex = 0;
  List<Widget> screens =const [ NewTask(),Done(),Archive()];
  List<String> title = ['task', 'done', 'archive'];

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeIndexState());
  }

  Database? database;
  List<Map> task = [];
  List<Map> doneTask = [];
  List<Map> archiveTask = [];

  void createDB() async {
    await openDatabase('om.db', version: 1,
        onCreate: (database, version) {
          print('create db');
          database
              .execute(
              'create table task(id integer primary key,time text,title text,date text,state text )')
              .then((value) {
            print('table created');
          }).catchError((error) {
            print('error is${error.toString()}');
          });
        },
        onOpen: (database) {
          getDataFromDB(database);
          print('db opend');
        }).
    then((value) {
      database = value;
      emit(AppCreateDBState());
    });
  }
  insertIntoDB({
    @required String? title,
    @required String? state,
    @required String? time,
    @required String? date,
  }) async {
    await database!.transaction((txn) {
      txn
          .rawInsert(
          'insert into task(time,date,title,state)values("$time","$date","$title","$state")')
          .then((value) {
        print('$value inserted successfully');
        emit(AppInsertDBState());
        // عاوز اجيب الداتاالجديده بقا
        getDataFromDB(database);
      }).catchError((error) {
        print('error is ${error.toString()}');
      });
      return Future(() => null);
    });
  }

  void getDataFromDB(database) {
    task = [];
    doneTask = [];
    archiveTask = [];
    emit(AppLoadingDBState());
    database!.rawQuery('select * from task').then((value) {
      value.forEach((element) {
        if (element['state'] == 'task') {
          task.add(element);
        } else if (element['state'] == 'archive') {
          archiveTask.add(element);
        } else {
          doneTask.add(element);
        }
      });

      emit(AppGetDBState());
    });
  }

  void updateData({
    @required String? status,
    @required int? id,
  }) async {
    database!.rawUpdate(
      'UPDATE task SET state = ? where id = ?',
      ['$status', id],
    ).then((value) {
      getDataFromDB(database);
      emit(AppUpdateDBState());
    });
  }

  void deleteData({
    @required int? id,
  }) async {
    database!.rawDelete('DELETE FROM task WHERE id = ?', [id]).then((value) {
      getDataFromDB(database);
      emit(AppDeleteDBState());
    });
  }

  bool showBottom = false;
  IconData fabIcon = Icons.add;

  void changeBottomShow({
    @required bool? isShow,
    @required IconData? icon,
  }) {
    showBottom = isShow!;
    fabIcon = icon!;
    emit(AppChangeBottomShow());
  }

}
