import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo/screen_pod.dart';
import 'package:todo/widgets/calendar.dart';
import 'package:todo/database/database_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateTodoPage extends ConsumerStatefulWidget {
  CreateTodoPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateTodoPage();
}

class _CreateTodoPage extends ConsumerState<CreateTodoPage> {
  // DatabaseHelper クラスのインスタンス取得
  final dbHelper = DatabaseHelper.instance;

  final TextEditingController _todoNameController = TextEditingController();
  final TextEditingController _todoContentController = TextEditingController();

  // List<int> items = [3, 4, 5];
  List<String> items = ['買い物', '旅行', '仕事'];
  // DropdownButtonで選択した値
  // int? _selectedItem;
  String? _selectedItem;

  // DropdownMenuItemの初期値を設定
  // final numberProvider = StateProvider<int?>((ref) {
  //   return 5;
  // });
  final numberProvider = StateProvider<String?>((ref) {
    return '旅行';
  });

  DateTime date = DateTime.now();
  bool setDeadline = false;

  @override
  Widget build(BuildContext context) {
    final screen = ScreenRef(context).watch(screenProvider);
    // final designW = screen.designW(350);
    final designH = screen.designH(750);

    // 選択した値をwatchで監視する
    final numberOfMember = ref.watch(numberProvider);

    return Container(
      // mainAxisSize: MainAxisSize.min,
      height: designH,
      child: Scaffold(
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
        body: ListView(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 50,
                  child: TextField(
                    controller: _todoNameController,
                    decoration: const InputDecoration(
                      border:
                          OutlineInputBorder(borderSide: BorderSide(width: 3)),
                      hintText: 'Todo名',
                    ),
                  ),
                ),
                SizedBox(
                  // height: 50,
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: _todoContentController,
                    decoration: const InputDecoration(
                      border:
                          OutlineInputBorder(borderSide: BorderSide(width: 3)),
                      hintText: 'Todo内容',
                    ),
                  ),
                ),
                SizedBox(
                  width: 350,
                  child: DropdownButton(
                    hint: const Text('カテゴリを選択'),
                    isExpanded: true,
                    value: _selectedItem,
                    items: items
                        // .map((item) => DropdownMenuItem<int>(
                        .map((item) => DropdownMenuItem<String>(
                              alignment: AlignmentDirectional.center,
                              value: item,
                              child: Text(item.toString()),
                            ))
                        .toList(),
                    onChanged: (value) {
                      // riverpodで保持している値を選択した値に更新する
                      ref.read(numberProvider.notifier).state = value;
                      // 画面に表示させるDropdownButtonの値を動的に変える
                      setState(() {
                        _selectedItem = value;
                      });
                      print(ref.read(numberProvider.notifier).state);
                    },
                  ),
                ),
                ElevatedButton(
                  // child: Text('カレンダー'),
                  child: (setDeadline)
                      ? Text(
                          "${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
                        )
                      : Text('期限なし'),
                  onPressed: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2099),
                      initialEntryMode: DatePickerEntryMode.calendarOnly,
                      // locale: Locale('ja', 'JP'),
                    );
                    if (selectedDate != null) {
                      setState(() {
                        date = selectedDate;
                        setDeadline = true;
                      });
                    }
                  },
                ),
                (setDeadline)
                    ? ElevatedButton(
                        child: Text('バツ'),
                        onPressed: () {
                          setState(() {
                            setDeadline = false;
                          });
                        },
                      )
                    : Text('非表示'),
                // ListView.builder(
                //   itemCount: _selectedEvents.length,
                //   itemBuilder: (context, index) {
                //     final event = _selectedEvents[index];
                //     return Card(
                //       child: ListTile(
                //         title: Text(event),
                //       ),
                //     );
                //   },
                // ),
                Row(
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
                      // onPressed: _query,
                      onPressed: () => print(_selectedItem),
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
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 登録ボタンクリック
  void _insert() async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnTodoName: '山田 太郎',
      DatabaseHelper.columnTodoContent: 35
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
      DatabaseHelper.columnTodoId: 1,
      DatabaseHelper.columnTodoName: '鈴木 一郎',
      DatabaseHelper.columnTodoContent: 48
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

  Widget categoryWidget(bool newFlag) {
    if (newFlag) {
      return SizedBox(
        height: 50,
        child: TextField(
          controller: _todoNameController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(borderSide: BorderSide(width: 3)),
            hintText: '新規カテゴリ',
          ),
        ),
      );
    } else {
      return SizedBox(
        height: 50,
        child: TextField(
          controller: _todoNameController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(borderSide: BorderSide(width: 3)),
            hintText: '既存カテゴリ',
          ),
        ),
      );
    }
  }
}
