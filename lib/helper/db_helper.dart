import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/blog.dart';

class Dbtype{
  static const String name='myBlog';
}

class BlogField{
  static const String id='id';
  static const String title='title';
  static const String image='image';
  static const String isFavourite='isFavourite';
}

class DBHelper{
  static final DBHelper _instance = DBHelper.internal();
  factory DBHelper() => _instance;

  static Database? _database;

  DBHelper.internal();

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await initDB('blogs.db');
    return _database;
  }

  Future<Database> initDB(String filePath) async {
    final dbPath=await getDatabasesPath();
    final path=join(dbPath,filePath);
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    const idType = 'VARCHAR PRIMARY KEY';
    const textType = 'TEXT NOT NULL';
    const specialText = 'VARCHAR NOT NULL';
    const boolType = 'BOOLEAN NOT NULL';
    // const integerType = 'INTEGER NOT NULL';

    await db.execute(
        '''CREATE TABLE ${Dbtype.name} (
       ${BlogField.id} $idType,
       ${BlogField.title} $specialText,
       ${BlogField.image} $textType,
       ${BlogField.isFavourite} $boolType
     )'''
    );
  }


  Future<Blog> create(Blog myblog) async {
    final db = await _instance.database;
    final json = myblog.toJson();
    final columns = {
      BlogField.id: json[BlogField.id],
      BlogField.title: json[BlogField.title],
      BlogField.image: json[BlogField.image],
      BlogField.isFavourite:json[BlogField.isFavourite]
    };

    final existingBlogs = await db!.query(
      Dbtype.name,
      where: '${BlogField.id} = ?',
      whereArgs: [json[BlogField.id]],
    );

    if (existingBlogs.isEmpty) {
      final id = await db.insert(Dbtype.name, columns);
      final newBlog = Blog.copy(id: id.toString(), source: myblog);
      return newBlog;
    } else {
      final existingBlog = Blog.fromJson(existingBlogs.first);
      return existingBlog;
    }

  }

  Future<int> update(Blog updatedBlog) async {
    final db = await _instance.database;
    final json = updatedBlog.toJson();

    final columns = {
      BlogField.title: json[BlogField.title],
      BlogField.image: json[BlogField.image],
      BlogField.isFavourite:json[BlogField.isFavourite]
    };

    final rowsAffected = await db!.update(
      Dbtype.name,
      columns,
      where: '${BlogField.id} = ?',
      whereArgs: [updatedBlog.id],
    );

    return rowsAffected;
  }

  Future<int> delete(String id) async {
    final db = await _instance.database;

    final rowsDeleted = await db!.delete(
      Dbtype.name,
      where: '${BlogField.id} = ?',
      whereArgs: [id],
    );

    return rowsDeleted;
  }

  Future<List<Blog>> readAllBlogs() async {
    final db = await _instance.database;

    final List<Map<String, dynamic>> result = await db!.query(Dbtype.name);

    final List<Blog> blogs = result.map((row) {
      return Blog(
        id: row[BlogField.id].toString(),
        title: row[BlogField.title] as String,
        image: row[BlogField.image] as String,
        isFavourite: row[BlogField.isFavourite]==1
      );
    }).toList();

    return blogs;
  }



}