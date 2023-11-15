// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:go_router/go_router.dart';

// Project imports:
import 'package:todo/pages/home.dart';
import 'package:todo/pages/initial.dart';
import 'package:todo/pages/account_registration.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  MobileAds.instance.initialize();

  runApp(MyApp());
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
      ),
      GoRoute(
        path: '/account_registration',
        builder: (context, state) => const AccountRegistrationPage(),
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
