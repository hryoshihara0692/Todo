// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:google_mobile_ads/google_mobile_ads.dart';

// Project imports:
import 'package:todo/components/ad_mob.dart';

import 'package:todo/pages/Item.dart';

import 'package:todo/database/database_helper.dart';

import 'package:uuid/uuid.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Item> items = [];

  final AdMob _adMob = AdMob();

  @override
  void initState() {
    super.initState();
    _adMob.load();
  }

  @override
  void dispose() {
    super.dispose();
    _adMob.dispose();
  }

  void add() {
    setState(
      () {
        items.add(Item.create(""));
      },
    );
  }

  void remove(String id) {
    final removedItem = items.firstWhere((element) => element.id == id);
    setState(
      () {
        items.removeWhere((element) => element.id == id);
      },
    );

    // itemのcontrollerをすぐdisposeすると怒られるので
    // 少し時間をおいてからdipose()
    Future.delayed(Duration(seconds: 1)).then(
      (value) {
        removedItem.dispose();
      },
    );
  }

  // DatabaseHelper クラスのインスタンス取得
  final dbHelper = DatabaseHelper.instance;

  // 登録ボタンクリック
  void _insert() async {
    var uuid = Uuid();
    var todoId = uuid.v4();

    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnId: todoId,
      DatabaseHelper.columnContent: 'たまごを買う',
      DatabaseHelper.columnIsChecked: 0,
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
      DatabaseHelper.columnContent: '修正したよ',
      DatabaseHelper.columnIsChecked: 1,
    };
    final rowsAffected = await dbHelper.update(row);
    print('更新しました。 ID：$rowsAffected ');
  }

  // 削除ボタンクリック
  void _delete() async {
    final id = await dbHelper.queryRowCount();
    final rowsDeleted = await dbHelper.delete(id!);
    print('削除しました。 $rowsDeleted ID: $id');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(
          children: [
            Text(items.toString()),
            ...items.map((item) => textFieldItem(item)),
            ElevatedButton(
              onPressed: () {
                add();
              },
              child: Text("追加"),
            ),
            ElevatedButton(
              child: Text(
                'Insert',
                style: TextStyle(fontSize: 35),
              ),
              onPressed: _insert,
            ),
            ElevatedButton(
              child: Text(
                'Query',
                style: TextStyle(fontSize: 35),
              ),
              onPressed: _query,
            ),
            ElevatedButton(
              child: Text(
                'Update',
                style: TextStyle(fontSize: 35),
              ),
              onPressed: _update,
            ),
            ElevatedButton(
              child: Text(
                'Delete',
                style: TextStyle(fontSize: 35),
              ),
              onPressed: _delete,
            ),
            // Admob
            FutureBuilder(
              future: AdSize.getAnchoredAdaptiveBannerAdSize(
                  Orientation.portrait,
                  MediaQuery.of(context).size.width.truncate()),
              builder: (BuildContext context,
                  AsyncSnapshot<AnchoredAdaptiveBannerAdSize?> snapshot) {
                if (snapshot.hasData) {
                  return SizedBox(
                    width: double.infinity,
                    child: _adMob.getAdBanner(),
                  );
                } else {
                  return Container(
                    height: _adMob.getAdBannerHeight(),
                    color: Colors.white,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget textFieldItem(Item item) {
    return Container(
      color: Colors.green,
      child: ListTile(
        leading: Checkbox(
          onChanged: (value) {},
          value: false,
        ),
        title: TextField(
          controller: item.controller,
          onChanged: (text) {
            setState(
              () {
                items = items
                    .map((e) => e.id == item.id ? item.change(text) : e)
                    .toList();
              },
            );
          },
        ),
        trailing: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            remove(item.id);
          },
        ),
        dense: true,
      ),
    );
  }
}

//==============================================================================
// class HomePage extends StatefulWidget {
//   const HomePage({super.key, required this.title});

//   final String title;

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final AdMob _adMob = AdMob();
//   int _counter = 0;
//   List<String> tasks = ["test", "てすと", "テスト"];

//   @override
//   void initState() {
//     super.initState();
//     _adMob.load();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _adMob.dispose();
//   }

//   void _incrementCounter() {
//     setState(() {
//       _counter++;
//       tasks.add('ボタン押したよ$_counter');
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             Expanded(
//               child: ListView(
//                 children: _createList(tasks),
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () => _incrementCounter(),
//               child: Text("a"),
//             ),
//             // Admob
//             FutureBuilder(
//               future: AdSize.getAnchoredAdaptiveBannerAdSize(
//                   Orientation.portrait,
//                   MediaQuery.of(context).size.width.truncate()),
//               builder: (BuildContext context,
//                   AsyncSnapshot<AnchoredAdaptiveBannerAdSize?> snapshot) {
//                 if (snapshot.hasData) {
//                   return SizedBox(
//                     width: double.infinity,
//                     child: _adMob.getAdBanner(),
//                   );
//                 } else {
//                   return Container(
//                     height: _adMob.getAdBannerHeight(),
//                     color: Colors.white,
//                   );
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }

// List<ListTile> _createList(List<String> tasks) {
//   var _list = <ListTile>[];

//   final TextEditingController _todoNameController = TextEditingController();

//   for (var task in tasks) {
//     _list.add(
//       ListTile(
//         leading: Container(
//           width: 30,
//           height: 30,
//           decoration: const BoxDecoration(
//             shape: BoxShape.rectangle,
//             color: Colors.blue,
//           ),
//         ),
//         title: TextField(
//           controller: _todoNameController,
//           decoration: const InputDecoration(
//             border: OutlineInputBorder(borderSide: BorderSide(width: 3)),
//             hintText: 'Todo名',
//           ),
//         ),
//         subtitle: Text(task),
//         trailing: Container(
//           width: 30,
//           height: 30,
//           margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
//           decoration: BoxDecoration(
//             shape: BoxShape.rectangle,
//             color: Colors.green,
//           ),
//         ),
//         dense: true,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.all(
//             Radius.circular(30),
//           ),
//         ),
//       ),
//     );
//   }
//   return _list;
// }
