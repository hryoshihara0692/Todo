import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

/*
https://yakiimosan.com/flutter-sqlite-basic/
*/

class DatabaseHelper {

  static final _databaseName = "todo.db"; // DB名
  static final _databaseVersion = 1; // スキーマのバージョン指定

  static final table = 'todo'; // テーブル名

  static final columnTodoId = 'todo_id'; // カラム名：ID
  static final columnTodoName = 'todo_name'; // カラム名:Name
  static final columnTodoContent = 'todo_content'; // カラム名：age
  static final columnTodoCompleteFlag = 'todo_complete_flag'; // カラム名：age
  static final columnCategoryId = 'category_id'; // カラム名：age
  static final columnCategoryName = 'category_Name'; // カラム名：age
  static final columnCreateUserId = 'create_user_id'; // カラム名：age
  static final columnAssignedUserId = 'assigned_user_id'; // カラム名：age
  static final columnReminderDate = 'reminder_date'; // カラム名：age
  static final columnReminderNumber = 'reminder_number'; // カラム名：age
  static final columnReminderEveryFlag = 'reminder_every_flags'; // カラム名：age
  static final columnReminderTime = 'reminder_time'; // カラム名：age
  static final columnReminderStartTime = 'reminder_start_time'; // カラム名：age
  static final columnDeadline = 'deadline'; // カラム名：age
  static final columnCreateDate = 'create_date'; // カラム名：age
  static final columnUpdateDate = 'update_date'; // カラム名：age
  static final columnGroupId = 'group_id'; // カラム名：age

  // DatabaseHelper クラスを定義
  DatabaseHelper._privateConstructor();
  // DatabaseHelper._privateConstructor() コンストラクタを使用して生成されたインスタンスを返すように定義
  // DatabaseHelper クラスのインスタンスは、常に同じものであるという保証
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Databaseクラス型のstatic変数_databaseを宣言
  // クラスはインスタンス化しない
  static Database? _database;

  // databaseメソッド定義
  // 非同期処理
  Future<Database?> get database async {
    // _databaseがNULLか判定
    // NULLの場合、_initDatabaseを呼び出しデータベースの初期化し、_databaseに返す
    // NULLでない場合、そのまま_database変数を返す
    // これにより、データベースを初期化する処理は、最初にデータベースを参照するときにのみ実行されるようになります。
    // このような実装を「遅延初期化 (lazy initialization)」と呼びます。
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // データベース接続
  _initDatabase() async {
    // アプリケーションのドキュメントディレクトリのパスを取得
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    // 取得パスを基に、データベースのパスを生成
    String path = join(documentsDirectory.path, _databaseName);
    // データベース接続
    return await openDatabase(path,
        version: _databaseVersion,
        // テーブル作成メソッドの呼び出し
        onCreate: _onCreate);
  }

  // テーブル作成
  // 引数:dbの名前
  // 引数:スキーマーのversion
  // スキーマーのバージョンはテーブル変更時にバージョンを上げる（テーブル・カラム追加・変更・削除など）
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnTodoId TEXT PRIMARY KEY,
            $columnTodoName TEXT NOT NULL,
            $columnTodoContent TEXT NOT NULL,
            $columnTodoCompleteFlag INTEGER NOT NULL,
            $columnCategoryId TEXT NOT NULL,
            $columnCategoryName TEXT NOT NULL,
            $columnCreateUserId TEXT NOT NULL,
            $columnAssignedUserId TEXT,
            $columnReminderDate TEXT,
            $columnReminderNumber TEXT,
            $columnReminderEveryFlag INTEGER,
            $columnReminderTime TEXT,
            $columnReminderStartTime TEXT,
            $columnDeadline TEXT,
            $columnCreateDate TEXT NOT NULL,
            $columnUpdateDate TEXT NOT NULL,
            $columnGroupId TEXT
          )
          ''');
  }

  // 登録処理
  Future<int> insert(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.insert(table, row);
  }

  // 照会処理
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database? db = await instance.database;
    return await db!.query(table);
  }

  // レコード数を確認
   Future<int?> queryRowCount() async {
    Database? db = await instance.database;
    return Sqflite.firstIntValue(await db!.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  //　更新処理
   Future<int> update(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    int id = row[columnTodoId];
    return await db!.update(table, row, where: '$columnTodoId = ?', whereArgs: [id]);
  }

  //　削除処理
   Future<int> delete(int id) async {
    Database? db = await instance.database;
    return await db!.delete(table, where: '$columnTodoId = ?', whereArgs: [id]);
  }
}