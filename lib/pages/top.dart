// Flutter imports:
import 'package:flutter/material.dart';

import 'package:todo/screen_pod.dart';

class TopPage extends StatefulWidget {
  const TopPage({super.key});

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  List<String> tasks = ["test", "てすと", "テスト"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: _createList(tasks),
              ),
            ),
            ElevatedButton(
              onPressed: () => tasks.add("ボタンタップ"),
              child: Text("a"),
            ),
          ],
        ),
      ),
    );
  }
}

List<ListTile> _createList(List<String> tasks) {
  var _list = <ListTile>[];

  for (var task in tasks) {
    _list.add(ListTile(
      leading: Container(
        width: 30,
        height: 30,
        decoration: const BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.blue,
        ),
      ),
      title: Text(task),
      subtitle: Text(task),
      trailing: Container(
        width: 30,
        height: 30,
        margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.green,
        ),
      ),
      dense: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(30),
        ),
      ),
    ));
  }
  // for (var i = 0; i < 3; i++) {
  //   _list.add(
  //     ListTile(
  //       leading: Container(
  //         width: 30,
  //         height: 30,
  //         decoration: const BoxDecoration(
  //           shape: BoxShape.rectangle,
  //           color: Colors.blue,
  //         ),
  //       ),
  //       title: const Text('サミットで卵買う'),
  //       subtitle: const Text('どうですか？'),
  //       trailing: Container(
  //         width: 30,
  //         height: 30,
  //         margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
  //         decoration: BoxDecoration(
  //           shape: BoxShape.rectangle,
  //           color: Colors.green,
  //         ),
  //       ),
  //       dense: true,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.all(
  //           Radius.circular(30),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  return _list;
}
