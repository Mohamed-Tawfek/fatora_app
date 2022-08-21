import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'fatora_state.dart';

const String nameMainTable = 'fatora';

class FatoraCubit extends Cubit<FatoraState> {
  FatoraCubit() : super(FatoraInitial());
  TextEditingController priceController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  static Database? database;
  List<Map> data = [];
  num total = 0;
  static FatoraCubit get(context) => BlocProvider.of(context);

  static Future<void> initDB() async {
    database = await openDatabase(nameMainTable, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE $nameMainTable (id INTEGER PRIMARY KEY, price REAL, name TEXT)');
    });
  }

  Future<void> getAllData() async {

    total = 0;
    await database!.rawQuery('SELECT * FROM $nameMainTable').then((value) {

      data = value;
      data.forEach((element) {
        total += element['price'];
      });
      emit(FatoraGetState());
    });

  }

  Future<void> insertToDB({
    required String name,
    required String price,
    required String date,
  }) async {
    await database!.transaction((txn) async {
      await txn.rawInsert(
          'INSERT INTO $nameMainTable(price, name) VALUES("$price", "$name")');
    }).then((value) {
      showToast(msg: 'تمت الاضافة بنجاح', state: ToastState.add);
      getAllData();
    });
  }

  Future<void> deleteAllData() async {
    await database!.rawDelete('DELETE FROM $nameMainTable').then((value) {
      showToast(msg: 'تم حذف الكل بنجاح', state: ToastState.delete);
      getAllData();
    });
  }

  Future<void> deleteASpecificItem({required int id}) async {
    await database!.rawDelete(
        'DELETE FROM $nameMainTable WHERE id = ?', [id]).then((value) {
      showToast(msg: 'تم الحذف بنجاح', state: ToastState.delete);
      getAllData();
    });
  }
}

enum ToastState { add, delete }

showToast({
  required String msg,
  required ToastState state,
}) {
  return Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: state == ToastState.add ? Colors.green : Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}
