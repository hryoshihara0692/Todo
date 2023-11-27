// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:google_mobile_ads/google_mobile_ads.dart';

// Project imports:
import 'package:todo/components/ad_mob.dart';
import 'package:todo/widgets/todo.dart';
import 'package:todo/widgets/my_divider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: 375,
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
                }),
          ],
        ),
      ),
    );
  }
}
