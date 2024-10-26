import 'package:floor/floor.dart';
import "mydatabase.dart";

@dao
abstract class MyDatabaseDao {
  @Query('SELECT * FROM Person')
  Future<List<MyDatabase>> findAllPersons();

  @Query('SELECT * FROM Person WHERE id = :id')
  Stream<MyDatabase?> findPersonById(int id);

  @insert
  Future<void> insertPerson(MyDatabase myDatabase);
}