// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:go_router/go_router.dart';

// Project imports:
import 'package:todo/pages/home.dart';
import 'package:todo/pages/initial.dart';
import 'package:todo/pages/account_registration.dart';
import 'package:todo/pages/login.dart';
// RiverPodの勉強用
// import 'package:todo/my_widget_s1.dart';
// import 'package:todo/my_widget_s2.dart';
// import 'package:todo/my_widget_s3.dart';
// import 'package:todo/my_widget_s4.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  MobileAds.instance.initialize();

  runApp(ProviderScope(child: MyApp(),) );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final router = GoRouter(
    // パス (アプリが起動したとき)
    initialLocation: '/',
    // パスと画面の組み合わせ
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const InitialPage(),
        // RiverPodの確認
        // builder: (context, state) => const MyWidget(),
      ),
      GoRoute(
        path: '/account_registration',
        builder: (context, state) => const AccountRegistrationPage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomePage(),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   title: 'Flutter Demo',
    //   theme: ThemeData(
    //     primarySwatch: Colors.blue,
    //   ),
    //   // home: const HomePage(title: 'Admob Demo'),
    //   // home: const InitialPage(),
    // );
    return MaterialApp.router(
      routeInformationProvider: router.routeInformationProvider,
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
    );
  }
}
