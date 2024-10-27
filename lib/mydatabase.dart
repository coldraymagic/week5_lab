import 'package:floor/floor.dart';

@entity
class MyDatabase {
  @primaryKey
  final int id;
  final String itemValue;

  MyDatabase(this.id,  this.itemValue);
}