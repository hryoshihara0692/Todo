import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:todo/components/ad_mob.dart';

class InitialPage extends StatefulWidget {
  // const initialPage({super.key});
  const InitialPage({super.key, required this.title});

  final String title;

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
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
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
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
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
