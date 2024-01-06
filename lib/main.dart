// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// Project imports:
import 'package:todo/pages/home.dart';
import 'package:todo/pages/create_account.dart';
import 'package:todo/pages/login.dart';
import 'package:todo/pages/category_todo.dart';
// RiverPodの勉強用
// import 'package:todo/my_widget_s1.dart';
// import 'package:todo/my_widget_s2.dart';
// import 'package:todo/my_widget_s3.dart';
// import 'package:todo/my_widget_s4.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  MobileAds.instance.initialize();

  runApp(ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('ja'),
      ],
      locale: const Locale('ja'),
      home: const HomePage(),
      // home: const InitialPage(),
    );
    // return MaterialApp(
    //   title: 'Flutter Demo',
    //   localizationsDelegates: const [
    //     GlobalMaterialLocalizations.delegate,
    //     GlobalWidgetsLocalizations.delegate,
    //     GlobalCupertinoLocalizations.delegate,
    //   ],
    //   // 他のMaterialAppの設定もここに追加できます
    //   builder: (context, child) {
    //     return Overlay(
    //       initialEntries: [
    //         OverlayEntry(
    //           builder: (context) => MaterialApp.router(
    //             debugShowCheckedModeBanner: false,
    //             routeInformationProvider: router.routeInformationProvider,
    //             routeInformationParser: router.routeInformationParser,
    //             routerDelegate: router.routerDelegate,
    //           ),
    //         ),
    //       ],
    //     );
    //   },
    // );
  }
}
