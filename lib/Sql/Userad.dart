import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String tableMima = 'mima';
final String columnId = '_id';
final String columnMimaname = 'mimaname';
final String columnPassword = 'password';

class Mima {
  int id;
  String mimaname;
  String password;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnMimaname: mimaname,
      columnPassword: password,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  Mima(int id, String mimaname, String password) {
    this.id = id;
    this.mimaname = mimaname;
    this.password = password;
  }

  Mima.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    mimaname = map[columnMimaname];
    password = map[columnPassword];
  }
}

class MimaSqlite {
  Database db;

  openSqlite() async {
    // 获取数据库文件的存储路径
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');

//根据数据库文件路径和数据库版本号创建数据库表
    db = await openDatabase(path, version: 2,
        onCreate: (Database db, int version) async {
          await db.execute('''
          CREATE TABLE $tableMima (
            $columnId INTEGER PRIMARY KEY, 
            $columnMimaname TEXT, 
            $columnPassword TEXT, )
          ''');
        });
  }

  // 插入一条书籍数据
  Future<Mima> insert(Mima mima) async {
    mima.id = await db.insert(tableMima, mima.toMap());
    return mima;
  }

  // 查找所有书籍信息
  Future<List<Mima>> queryAll() async {
    List<Map> maps = await db.query(tableMima, columns: [
      columnId,
      columnMimaname,
      columnPassword,
    ]);

    if (maps == null || maps.length == 0) {
      return null;
    }

    List<Mima> mimas = [];
    for (int i = 0; i < maps.length; i++) {
      mimas.add(Mima.fromMap(maps[i]));
    }
    return mimas;
  }

  // 根据ID查找书籍信息
  Future<Mima> getMima(int id) async {
    List<Map> maps = await db.query(tableMima,
        columns: [
          columnId,
          columnMimaname,
          columnPassword,
        ],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Mima.fromMap(maps.first);
    }
    return null;
  }

  // 根据ID删除书籍信息
  Future<int> delete(int id) async {
    return await db.delete(tableMima, where: '$columnId = ?', whereArgs: [id]);
  }

  // 更新书籍信息
  Future<int> update(Mima mima) async {
    return await db.update(tableMima, mima.toMap(),
        where: '$columnId = ?', whereArgs: [mima.id]);
  }

  // 记得及时关闭数据库，防止内存泄漏
  close() async {
    await db.close();
  }
}
