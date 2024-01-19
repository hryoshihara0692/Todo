// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:google_mobile_ads/google_mobile_ads.dart';

// Project imports:
import 'package:todo/components/ad_mob.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AdMob _adMob = AdMob();
  int _counter = 0;
  List<String> tasks = ["test", "てすと", "テスト"];

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
      tasks.add('ボタン押したよ$_counter');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: _createList(tasks),
              ),
            ),
            ElevatedButton(
              onPressed: () => _incrementCounter(),
              child: Text("a"),
            ),
            // Admob
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
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

List<ListTile> _createList(List<String> tasks) {
  var _list = <ListTile>[];

  for (var task in tasks) {
    _list.add(
      ListTile(
        leading: Container(
          width: 30,
          height: 30,
          decoration: const BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.blue,
          ),
        ),
        title: Text(task),
        subtitle: Text(task),
        trailing: Container(
          width: 30,
          height: 30,
          margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.green,
          ),
        ),
        dense: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
      ),
    );
  }
  return _list;
}
