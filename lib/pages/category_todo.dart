// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:todo/screen_pod.dart';

// Project imports:
import 'package:todo/components/ad_mob.dart';
import 'package:todo/widgets/todo.dart';
import 'package:todo/widgets/my_divider.dart';

class CategoryTodoPage extends StatefulWidget {
  const CategoryTodoPage({super.key});

  @override
  State<CategoryTodoPage> createState() => _CategoryTodoPageState();
}

class _CategoryTodoPageState extends State<CategoryTodoPage> {
  final AdMob _adMob = AdMob();

  @override
  void initState() {
    super.initState();
    _adMob.load();
  }

  @override
  void dispose() {
    super.dispose();
    _adMob.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screen = ScreenRef(context).watch(screenProvider);
    final designW = screen.designW(110);
    final designH = screen.designH(105);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(175, 255, 130, 130),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          flexibleSpace: Container(
            // decoration: BoxDecoration(
            //   image: DecorationImage(
            //       image: AssetImage('images/tomato.png'), fit: BoxFit.cover),
            // ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 100,
              // margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
              decoration: const BoxDecoration(
                shape: BoxShape.rectangle,
                color: Color.fromARGB(175, 255, 130, 130),
              ),
              child: Image.asset('images/tomato.png'),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Color.fromARGB(175, 255, 130, 130),
                ),
                child: ListView(
                  children: const [
                    Todo(),
                    MyDivider(),
                    Todo(),
                    MyDivider(),
                    Todo(),
                    MyDivider(),
                    Todo(),
                    MyDivider(),
                    Todo(),
                    MyDivider(),
                    Todo(),
                    MyDivider(),
                    Todo(),
                    MyDivider(),
                    Todo(),
                    MyDivider(),
                    Todo(),
                    MyDivider(),
                    Todo(),
                    MyDivider(),
                    Todo(),
                    MyDivider(),
                    Todo(),
                    MyDivider(),
                    Todo(),
                    MyDivider(),
                    Todo(),
                    MyDivider(),
                    Todo(),
                    MyDivider(),
                    Todo(),
                    MyDivider(),
                    Todo(),
                    MyDivider(),
                    Todo(),
                    MyDivider(),
                    Todo(),
                    MyDivider(),
                    Todo(),
                    MyDivider(),
                  ],
                ),
              ),
            ),
            FutureBuilder(
              future: AdSize.getAnchoredAdaptiveBannerAdSize(
                  Orientation.portrait,
                  MediaQuery.of(context).size.width.truncate()),
              builder: (BuildContext context,
                  AsyncSnapshot<AnchoredAdaptiveBannerAdSize?> snapshot) {
                if (snapshot.hasData) {
                  return SizedBox(
                    width: double.infinity,
                    child: _adMob.getAdBanner(),
                  );
                } else {
                  return Container(
                    height: _adMob.getAdBannerHeight(),
                    color: Colors.white,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
