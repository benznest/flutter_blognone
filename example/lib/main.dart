import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_blognone/dao/node_title_dao.dart';
import 'package:flutter_blognone/flutter_blognone.dart';

Future main() async {
//  FlutterBlognone bn = FlutterBlognone();
//  await bn.fetchNodeTitleList();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FlutterBlognone bn = FlutterBlognone();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Blognone'),
        ),
        body: FutureBuilder(
            future: bn.fetchNodeTitleList(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<NodeTitleDao> listNode = snapshot.data;
                return ListView.builder(
                  itemCount: listNode.length,
                  itemBuilder: (context, i) {
                    return Text(listNode[i].title);
                  },
                );
              } else {
                return Container();
              }
            }),
      ),
    );
  }
}
