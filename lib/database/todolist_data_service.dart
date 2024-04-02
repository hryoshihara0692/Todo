import 'package:cloud_firestore/cloud_firestore.dart';

class TodoListDataService {
  static Future<Map<String, dynamic>> getTodoListData(String todoListID) async {
    try {
      // Firestoreのコレクション参照
      CollectionReference todoLists =
          FirebaseFirestore.instance.collection('TODOLIST');

      // ユーザーIDを指定してドキュメントを取得
      DocumentSnapshot todoListDoc = await todoLists.doc(todoListID).get();

      // ドキュメントが存在するか確認
      if (todoListDoc.exists) {
        // ドキュメント内のデータを取得
        Map<String, dynamic>? todoListData =
            todoListDoc.data() as Map<String, dynamic>;

        //空の場合、チェックしてもしなくても空を返すならチェック不要では…
        if (todoListData.isNotEmpty) {
          return todoListData;
        } else {
          print('指定されたユーザーIDのドキュメントが存在しません');
          return {};
        }
      } else {
        print('指定されたユーザーIDのドキュメントが存在しません');
        return {};
      }
    } catch (e) {
      print('データ取得中にエラーが発生しました: $e');
      return {};
    }
  }

  ///
  /// FirestoreへTodoListの登録
  ///
  static Future<void> createTodoListData(
      String todolistId, Map<String, dynamic> todolistData) async {
    await FirebaseFirestore.instance
        .collection('TODOLIST')
        .doc(todolistId)
        .set(todolistData);
  }
}
