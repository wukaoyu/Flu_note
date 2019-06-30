import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String tableNote = 'Note';
final String columnId = '_id';
final String columnName = 'name';
final String columnContent = 'content';
final String columnDate = 'date';
final String columnType = 'type';

class Note {
  int id;
  String name;
  String content;
  String date;
  String type;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnName: name,
      columnContent: content,
      columnDate: date,
      columnType: type
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  Note(int id, String name, String content, String date,
      String type) {
    this.id = id;
    this.name = name;
    this.content = content;
    this.date = date;
    this.type = type;
  }

  Note.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    name = map[columnName];
    content = map[columnContent];
    date = map[columnDate];
    type = map[columnType];
  }
}
class NoteSqlite{
  Database db;
  openSqlite() async {
    // 获取数据库文件的存储路径
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');

//根据数据库文件路径和数据库版本号创建数据库表
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
          CREATE TABLE $tableNote (
            $columnId INTEGER PRIMARY KEY, 
            $columnName TEXT, 
            $columnContent TEXT, 
            $columnDate TEXT, 
            $columnType TEXT)
          ''');
        });
  }
  
  // 插入一条数据
  Future<Note> insert(Note note) async {
    note.id = await db.insert(tableNote, note.toMap());
    return note;
  }

  // 查找所有书籍信息
  Future<List<Note>> queryAll() async {
    List<Map> maps = await db.query(tableNote, columns: [
      columnId,
      columnName,
      columnContent,
      columnDate,
      columnType
    ]);

    if (maps == null || maps.length == 0) {
      return null;
    }

    List<Note> notes = [];
    for (int i = 0; i < maps.length; i++) {
      notes.add(Note.fromMap(maps[i]));
    }
    return notes;
  }

  // 根据ID查找书籍信息
  Future<Note> getnote(int id) async {
    List<Map> maps = await db.query(tableNote,
        columns: [
          columnId,
          columnName,
          columnContent,
          columnDate,
          columnType
        ],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Note.fromMap(maps.first);
    }
    return null;
  }
  
  // 根据ID删除书籍信息
  Future<int> delete(int id) async {
    return await db.delete(tableNote, where: '$columnId = ?', whereArgs: [id]);
  }
  
  // 更新书籍信息
  Future<int> update(Note note) async {
    return await db.update(tableNote, note.toMap(),
        where: '$columnId = ?', whereArgs: [note.id]);
  }


  // 记得及时关闭数据库，防止内存泄漏
  close() async {
    await db.close();
  }
}