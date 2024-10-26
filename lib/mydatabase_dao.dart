import 'package:floor/floor.dart';
import "mydatabase.dart";

@dao
abstract class MyDatabaseDao {
  @Query('SELECT * FROM MyDatabase')
  Future<List<MyDatabase>> findAllData();

  @Query('SELECT * FROM MyDatabase WHERE id = :id')
  Stream<MyDatabase?> findDataById(int id);

  @insert
  Future<void> insertData(MyDatabase myDatabase);

  @Query('DELETE FROM MyDatabase WHERE id = :id')
  Future<void> deleteDataById(int id);
}