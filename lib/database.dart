import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:sqflite_common_ffi_web/setup.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'mydatabase_dao.dart';
import 'mydatabase.dart';

part 'database.g.dart'; // the generated code will be there

@Database(version: 1, entities: [MyDatabase])
abstract class AppDatabase extends FloorDatabase {
  MyDatabaseDao get myDatabaseDao;
}