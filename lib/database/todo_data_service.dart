import 'package:cloud_firestore/cloud_firestore.dart';

class TodoDataService {
  ///
  /// ※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※
  /// Streamでやっているため、
  /// Listで直接データ取得する本関数は未使用
  /// FirestoreからTodoListIDが一致するTODO取得
  /// ※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※
  ///
  static Future<List<Map<String, dynamic>>> getTodoData(
      String? todoListId) async {
    if (todoListId != null) {
      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('TODO')
            .where('TodoListID', isEqualTo: todoListId)
            .get();

        List<Map<String, dynamic>> todoList = [];

        //取得したTodoの更新や削除処理の際に必要となる、DocumentIDを取得しMapに追加する
        querySnapshot.docs.forEach((document) {
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          data['DocumentID'] = document.id;
          todoList.add(data);
        });

        if (todoList.isNotEmpty) {
          return todoList;
        } else {
          //Todoが空なら空リストを返す
          return [];
        }
      } catch (e) {
        //Todo取得でエラーが起きたら空リストを返す
        return [];
      }
    } else {
      //Todoが空なら空リストを返す(String?対策でやってるっぽい)
      return [];
    }
  }

  ///
  /// FirestoreへTodoの登録
  ///
  static void createTodoData(
      String documentId, Map<String, dynamic> todoData) async {
    await FirebaseFirestore.instance
        .collection('TODO')
        .doc(documentId)
        .set(todoData);
  }

  ///
  /// FirestoreのTodoの内容更新
  ///
  static Future<void> updateTodoContentData(String documentId, String content) async {
    await FirebaseFirestore.instance.collection('TODO').doc(documentId).update({
      'Content': content,
      'UpdatedAt': Timestamp.fromDate(DateTime.now()),
    }).then((_) {
      // 更新が成功した場合の処理
      print('Field updated successfully.');
    }).catchError((error) {
      // 更新が失敗した場合のエラーハンドリング
      print('Failed to update field : $error');
    });
  }

  static void updateTodoIsCheckedData(String documentId, int isChecked) async {
    FirebaseFirestore.instance.collection('TODO').doc(documentId).update({
      'isChecked': isChecked,
      'UpdatedAt': Timestamp.fromDate(DateTime.now()),
    }).then((_) {
      // 更新が成功した場合の処理
      print('Field updated successfully.');
    }).catchError((error) {
      // 更新が失敗した場合のエラーハンドリング
      print('Failed to update field : $error');
    });
  }

  static void deleteTodoData(String documentId) async {
    FirebaseFirestore.instance
        .collection('TODO')
        .doc(documentId)
        .delete()
        .then((value) {
      print('Document with ID $documentId deleted successfully.');
    }).catchError((error) {
      print('Failed to delete document: $error');
    });
  }
}
