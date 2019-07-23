import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_blognone/dao/blognone_node_title_dao.dart';
import 'package:flutter_blognone/flutter_blognone.dart';

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
      body: Container(
        child: FutureBuilder(
            future: bn.fetchNodeTitleList(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<BlognoneNodeTitleDao> listNode = snapshot.data;
                return ListView.builder(
                  itemCount: listNode.length,
                  itemBuilder: (context, i) {
                    return buildRowNodeTitle(listNode[i]);
                  },
                );
              } else {
                return Container();
              }
            }),
      ),
    ));
  }

  Widget buildRowNodeTitle(BlognoneNodeTitleDao nodeTitle) {
    return Container(
      padding: EdgeInsets.all(16),
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[300], width: 1),
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Image.network(
                nodeTitle.urlImage,
                width: 50,
              ),
              SizedBox(
                width: 8,
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Text(
                      nodeTitle.title,
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                ),
              )
            ],
          ),
          buildTagsContainer(nodeTitle.tags),
          Text(
            nodeTitle.content,
            style: TextStyle(fontSize: 12, color: Colors.grey[700]),
          )
        ],
      ),
    );
  }

  buildTagsContainer(List<String> tags) {
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: 8),
      child: Wrap(spacing: 4,
          alignment: WrapAlignment.start,
          runAlignment: WrapAlignment.start,
          direction: Axis.horizontal,
          children: <Widget>[for (String tag in tags) Container(padding: EdgeInsets.all(4), decoration: BoxDecoration(border: Border.all(color: Colors.grey[300], width: 1)), child: Text(tag,style: TextStyle(fontSize: 12),))]),
    );
  }
}
