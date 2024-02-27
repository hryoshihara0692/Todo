import 'package:cloud_firestore/cloud_firestore.dart';

class TodoDataService {
  static Future<List<Map<String, dynamic>>> getTodoData(
      String? todoListId) async {
    if (todoListId != null) {
      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('TODO')
            .where('TodoListID', isEqualTo: todoListId)
            .get();

        List<Map<String, dynamic>> todoList = [];

        querySnapshot.docs.forEach((document) {
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          data['DocumentID'] = document.id; // DocumentIDを追加
          todoList.add(data);
        });

        if (todoList.isNotEmpty) {
          return todoList;
        } else {
          print('指定されたユーザーIDのドキュメントが存在しません');
          return [];
        }
      } catch (e) {
        print('データ取得中にエラーが発生しました: $e');
        return [];
      }
    } else {
      return [];
    }
  }

  static void createTodoData(
      String documentId, Map<String, dynamic> todoData) async {
    await FirebaseFirestore.instance
        .collection('TODO')
        .doc(documentId)
        .set(todoData);
  }

  static void updateTodoContentData(String documentId, String content) async {
    FirebaseFirestore.instance
        .collection('TODO')
        .doc(documentId)
        .update({
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
    FirebaseFirestore.instance
        .collection('TODO')
        .doc(documentId)
        .update({
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
