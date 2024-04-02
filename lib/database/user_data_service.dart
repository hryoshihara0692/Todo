import 'package:cloud_firestore/cloud_firestore.dart';

class UserDataService {
  static Future<Map<String, dynamic>> getUserData(String userId) async {
    try {
      // Firestoreのコレクション参照
      CollectionReference users = FirebaseFirestore.instance.collection('USER');

      // ユーザーIDを指定してドキュメントを取得
      DocumentSnapshot userDoc = await users.doc(userId).get();

      // ドキュメントが存在するか確認
      if (userDoc.exists) {
        // ドキュメント内のデータを取得
        Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>;

        //空の場合、チェックしてもしなくても空を返すならチェック不要では…
        if (userData.isNotEmpty) {
          return userData;
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

  static Future<Map<String, dynamic>> getUserDataSelectedByTodoListID(
      String todoListID) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('USER')
          .where(todoListID, arrayContains: true)
          .get();

      return {};
    } catch (e) {
      print('データ取得中にエラーが発生しました: $e');
      return {};
    }
  }

  ///
  /// FirestoreへUSERの登録
  ///
  static Future<void> createUserData(
      String documentId, Map<String, dynamic> userData) async {
    await FirebaseFirestore.instance
        .collection('USER')
        .doc(documentId)
        .set(userData);
  }

  ///
  /// FirestoreへUSERの登録
  ///
  static Future<void> addTodoListForUserData(
      String uid, String todoListId, String todoListName) async {
    // Firestoreのコレクション参照
    CollectionReference users = FirebaseFirestore.instance.collection('USER');

    DocumentReference docRef = users.doc(uid);

    // ドキュメントを更新（既存のデータとマージ）
    await docRef.update({
      'TodoLists.$todoListId': todoListName,
    }).catchError((error) {
      print("ドキュメントの更新中にエラーが発生しました： $error");
    });
  }
}
