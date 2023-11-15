// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:google_mobile_ads/google_mobile_ads.dart';

// Project imports:
import 'package:todo/components/ad_mob.dart';
import 'package:todo/widgets/todo.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AdMob _adMob = AdMob();
  int _counter = 0;

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

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Divider(
              height: 0,
              thickness: 3,
              indent: 0,
              endIndent: 0,
              color: Colors.black,
            ),
            Todo(),
            const Divider(
              height: 0,
              thickness: 3,
              indent: 0,
              endIndent: 0,
              color: Colors.black,
            ),
            Todo(),
            const Divider(
              height: 0,
              thickness: 3,
              indent: 0,
              endIndent: 0,
              color: Colors.black,
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
