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
}
