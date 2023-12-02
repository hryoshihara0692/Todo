import 'package:flutter/material.dart';
import 'package:todo/screen_pod.dart';
import 'package:go_router/go_router.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/database/database_helper.dart';

class CreateTodoPage extends StatelessWidget {
  CreateTodoPage({super.key});

  // DatabaseHelper クラスのインスタンス取得
  final dbHelper = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    final screen = ScreenRef(context).watch(screenProvider);
    // final designW = screen.designW(350);
    final designH = screen.designH(60);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
            // 閉じるときは
            // ネストしているModal内のRouteではなく、root側のNavigatorを指定する必要がある
            onPressed: () {
              print('object');
              Navigator.of(context, rootNavigator: true).pop();
            },
            icon: Icon(Icons.close)),
        // title: Text('Modal'),
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          ElevatedButton(
            child: Text(
              '登録',
              style: TextStyle(fontSize: 35),
            ),
            onPressed: _insert,
          ),
          ElevatedButton(
            child: Text(
              '照会',
              style: TextStyle(fontSize: 35),
            ),
            onPressed: _query,
          ),
          ElevatedButton(
            child: Text(
              '更新',
              style: TextStyle(fontSize: 35),
            ),
            onPressed: _update,
          ),
          ElevatedButton(
            child: Text(
              '削除',
              style: TextStyle(fontSize: 35),
            ),
            onPressed: _delete,
          ),
        ],
      ),
    );
  }

  // 登録ボタンクリック
  void _insert() async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnName: '山田 太郎',
      DatabaseHelper.columnAge: 35
    };
    final id = await dbHelper.insert(row);
    print('登録しました。id: $id');
  }

  // 照会ボタンクリック
  void _query() async {
    final allRows = await dbHelper.queryAllRows();
    print('全てのデータを照会しました。');
    allRows.forEach(print);
  }

  // 更新ボタンクリック
  void _update() async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnId: 1,
      DatabaseHelper.columnName: '鈴木 一郎',
      DatabaseHelper.columnAge: 48
    };
    final rowsAffected = await dbHelper.update(row);
    print('更新しました。 ID : $rowsAffected ');
  }

  // 削除ボタンクリック
  void _delete() async {
    final id = await dbHelper.queryRowCount();
    final rowsDeleted = await dbHelper.delete(id!);
    print('削除しました。 $rowsDeleted ID: $id');
  }
}
