import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_blognone/dao/blognone_node_title_dao.dart';
import 'package:flutter_blognone/flutter_blognone.dart';
import 'package:flutter_blognone_example/ui/screens/node_title_list_screen.dart';

Future main() async {
//  FlutterBlognone bn = FlutterBlognone();
//  await bn.fetchNodeContentList(printJson: true);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: NodeTitleListScreen());
  }
}
