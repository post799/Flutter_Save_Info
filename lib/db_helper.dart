import 'person_model.dart';
import 'package:path/path.dart' show join;
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;

class DBHelper {
  static Database _db;
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return _db;
  }

//Initialize the database
  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'person.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

//Create a database using a sql query
  _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE person (id INTEGER PRIMARY KEY, name TEXT, phone TEXT)');
  }

//Add person details
  Future<Person> add(Person person) async {
    var dbClient = await db;
    person.id = await dbClient.insert('person', person.toMap());
    return person;
  }

//Retrieve person details
  Future<List<Person>> getPerson() async {
    var dbClient = await db;
    List<Map> maps =
        await dbClient.query('person', columns: ['id', 'name', 'phone']);
    List<Person> persons = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        persons.add(Person.fromMap(maps[i]));
      }
    }
    return persons;
  }

//Delete person details
  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(
      'person',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

//Update person details
  Future<int> update(Person person) async {
    var dbClient = await db;
    return await dbClient.update(
      'person',
      person.toMap(),
      where: 'id = ?',
      whereArgs: [person.id],
    );
  }

//Finally close the database
  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
