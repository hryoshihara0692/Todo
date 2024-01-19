// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// Project imports:
import 'package:todo/pages/home.dart';
import 'package:todo/pages/top.dart';
// RiverPodの勉強用
// import 'package:todo/my_widget_s1.dart';
// import 'package:todo/my_widget_s2.dart';
// import 'package:todo/my_widget_s3.dart';
// import 'package:todo/my_widget_s4.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  //Flutterで必要だった記憶
  WidgetsFlutterBinding.ensureInitialized();

  //Firebase(Firestone)で必要
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //GoogleAdsの初期化
  MobileAds.instance.initialize();

  //アプリの実行
  runApp(ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //TODO 何のタイトル？
      title: 'Flutter Demo',
      //TODO 何のテーマカラー？
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //TODO 日本語アプリとしての設定のつもりだがおそらくエラー
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('ja'),
      ],

      //初期起動画面
      home: const TopPage(),
    );
  }
}
