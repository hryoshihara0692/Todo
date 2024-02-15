import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/database/user_data_service.dart';

// class CategoryDropdown extends StatefulWidget {
//   CategoryDropdown({Key? key}) : super(key: key);

//   @override
//   _CategoryDropdownState createState() => _CategoryDropdownState();
// }
class CategoryDropdown extends StatefulWidget {
  final void Function(String?) onSelectTodoListId; // コールバック関数の定義

  CategoryDropdown({Key? key, required this.onSelectTodoListId})
      : super(key: key);

  @override
  _CategoryDropdownState createState() => _CategoryDropdownState();
}

class _CategoryDropdownState extends State<CategoryDropdown> {
  String? selectedTodoListId; // 選択されたToDoリストのIDを保持する変数

  @override
  Widget build(BuildContext context) {
    //User
    final String? uid = FirebaseAuth.instance.currentUser?.uid.toString();

    if (uid != null) {
      return FutureBuilder<Map<String, dynamic>>(
        future: UserDataService.getUserData(uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // データ取得中の表示
          } else if (snapshot.hasError) {
            return Text('エラー: ${snapshot.error}');
          } else {
            final userData = snapshot.data;
            if (userData != null) {
              // userDataの各エントリをDropdownMenuItemに変換する
              List<DropdownMenuItem<String>> dropdownItems =
                  userData.entries.map((entry) {
                final String value = entry.key;
                final String text = entry.value;
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(text),
                );
              }).toList();

              // 初期値を設定する
              if (selectedTodoListId == null) {
                // selectedTodoListId = userData.keys.first;
                selectedTodoListId = uid;
              }

              return DropdownButton<String>(
                value: selectedTodoListId, // 初期値を設定する
                items: dropdownItems,
                onChanged: (String? selectedValue) {
                  setState(() {
                    selectedTodoListId = selectedValue; // 選択された値を保持する
                    widget.onSelectTodoListId(selectedValue); // コールバック関数を呼び出す
                  });
                },
              );
            } else {
              return Text("userDataがnullです");
            }
          }
        },
      );
    } else {
      return Text("uidはnullです");
    }
  }
}
