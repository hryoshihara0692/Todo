import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/database/user_data_service.dart';

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

  ///
  /// FirestoreのTodoの内容更新
  ///
  static Future<void> updateTodoListName(
      String todolistId, String todoListName, List<String> userIDs) async {
    await FirebaseFirestore.instance
        .collection('TODOLIST')
        .doc(todolistId)
        .update({
      'TodoListName': todoListName,
      'UpdatedAt': Timestamp.fromDate(DateTime.now()),
    }).then((_) {
      // 更新が成功した場合の処理
      print('Field updated successfully.');
    }).catchError((error) {
      // 更新が失敗した場合のエラーハンドリング
      print('Failed to update field : $error');
    });

    userIDs.forEach((element) async {
      await UserDataService.updateUserTodoListsEasy(element, todolistId, todoListName);
     });
  }

  ///
  /// FirestoreのTodoの内容更新
  ///
  static Future<void> updateTodoListEditingPermission(
      String todolistId, bool editingPermission) async {
    int editingPermissionNumber = editingPermission ? 1 : 0;
    await FirebaseFirestore.instance
        .collection('TODOLIST')
        .doc(todolistId)
        .update({
      'EditingPermission': editingPermissionNumber,
      'UpdatedAt': Timestamp.fromDate(DateTime.now()),
    }).then((_) {
      // 更新が成功した場合の処理
      print('Field updated successfully.');
    }).catchError((error) {
      // 更新が失敗した場合のエラーハンドリング
      print('Failed to update field : $error');
    });
  }
}
