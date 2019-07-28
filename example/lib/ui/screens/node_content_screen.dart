import 'package:flutter/material.dart';
import 'package:flutter_blognone/dao/blognone_node_comment_item_dao.dart';
import 'package:flutter_blognone/dao/blognone_node_content_dao.dart';
import 'package:flutter_blognone/flutter_blognone.dart';
import 'package:flutter_html/flutter_html.dart';

class NodeContentScreen extends StatefulWidget {
  final int nodeId;

  NodeContentScreen({@required this.nodeId});

  @override
  _NodeContentScreenState createState() => _NodeContentScreenState();
}

class _NodeContentScreenState extends State<NodeContentScreen> {
  FlutterBlognone bn = FlutterBlognone();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Blognone'),
      ),
      body: Container(
        child: FutureBuilder(
            future: bn.fetchNodeContentList(nodeId: widget.nodeId, printJson: true),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                BlognoneNodeContentDao nodeContent = snapshot.data;
                return buildNodeContentContainer(nodeContent);
              } else if (snapshot.hasError) {
                return Container(child: Text(snapshot.error.toString()));
              } else {
                return Container();
              }
            }),
      ),
    );
  }

  Widget buildNodeContentContainer(BlognoneNodeContentDao node) {
    return CustomScrollView(slivers: [
      SliverList(
        delegate: SliverChildListDelegate([
          Container(
              padding: EdgeInsets.all(16),
              width: double.infinity,
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey[300], width: 1),
                borderRadius: BorderRadius.circular(6.0),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                Row(children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          node.title,
                          style: TextStyle(fontSize: 16),
                        )
                      ],
                    ),
                  )
                ]),
                SizedBox(height: 8),
                Text("โดย " + node.writer + " " + node.date, style: TextStyle(fontSize: 12, color: Colors.grey[800])),
                buildTagsContainer(node.tags),
                Html(data: """ ${node.contentFull} """),
              ])),
          for (BlognoneNodeCommentItemDao comment in node.comments.items) buildRowComment(comment)
        ]),
      ),
    ]);
  }

  Container buildRowComment(BlognoneNodeCommentItemDao comment, {bool isReplyComment = false}) {
    return Container(
        padding: EdgeInsets.only(left: 8, top: 8, bottom: 8, right: isReplyComment ? 2 : 8),
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
            Text("By ${comment.username} , ${comment.datetime}"),
            Html(data: """ ${comment.html} """),
            SizedBox(height: 16),
            for (BlognoneNodeCommentItemDao item in comment.items) buildRowComment(item,isReplyComment: true)
          ],
        ));
  }

  buildTagsContainer(List<String> tags) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Wrap(spacing: 4, alignment: WrapAlignment.start, runAlignment: WrapAlignment.start, direction: Axis.horizontal, children: <Widget>[
        for (String tag in tags)
          Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(border: Border.all(color: Colors.grey[300], width: 1)),
              child: Text(
                tag,
                style: TextStyle(fontSize: 12),
              ))
      ]),
    );
  }
}
