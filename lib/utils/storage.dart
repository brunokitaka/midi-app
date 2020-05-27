import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'dart:async';
import 'dart:io';

class DbConnection {

  static final _connection = new DbConnection.internal();
  factory DbConnection() => _connection;
  DbConnection.internal();

  static var _database;

  Future get getDatabase async {
    if(_database != null){
      return _database;
    }
    else{
      _database = await initDatabase();
      return _database;
    }
  }
      
  initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "midi.db");
    return await openDatabase(path, version: 1, onCreate: _onCreate, onOpen: _onOpen);
  }

  void _onOpen(Database database) async {
    // Database version is updated, alter the table
    await database.execute("CREATE TABLE IF NOT EXISTS user " + 
    "(userId INTEGER)");
  }

  void _onCreate(Database database, int version) async {
    await database.execute(
      "CREATE TABLE idea " +
      "(idIdea INTEGER PRIMARY KEY AUTOINCREMENT, " +
      "path TEXT, " +
      "name TEXT)"
    );
    await database.execute("CREATE TABLE user " + 
    "(userId INTEGER)"
    );
    await database.execute("CREATE TABLE userIdea " +
    "(idIdea INTEGER," +
    "userId INTEGER)"
    );
  }

  Future insertUser(userId) async {
    Database database = await getDatabase;
    var result = await database.rawQuery("INSERT INTO user (userId) VALUES ($userId )");
    return result.toList();
  }

  Future<List> selectUser(userId) async {
    Database database = await getDatabase;
    var result = await database.rawQuery("SELECT * FROM user WHERE userId = $userId");
    return result.toList();
  }

  Future<List> selectUserIdeas(userId) async {
    Database database = await getDatabase;
    var result = await database.rawQuery("SELECT idIdea FROM userIdea WHERE userId = $userId");
    print(result);
    return result.toList();
  }

  Future<List> selectIdeasPaths(ideaId) async {
    Database database = await getDatabase;
    var result = await database.rawQuery("SELECT * FROM idea WHERE idIdea = $ideaId");
    print(result);
    return result.toList();
  }

  Future<int> insertIdea(Map<String, dynamic> toDo) async {
    Database database = await getDatabase;
    int insertID = await database.insert("idea", toDo);
    return insertID;
  }

  Future<int> insertUserIdea(Map<String, dynamic> toDo) async {
    Database database = await getDatabase;
    int insertID = await database.insert("userIdea", toDo);
    return insertID;
  }

  Future closeDatabase() async {
    Database database = await getDatabase;
    return database.close();
  }

}