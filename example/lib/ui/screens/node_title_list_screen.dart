import 'package:flutter/material.dart';
import 'package:flutter_blognone/dao/blognone_node_title_dao.dart';
import 'package:flutter_blognone/flutter_blognone.dart';
import 'package:flutter_blognone_example/node_title_list_mode.dart';
import 'package:flutter_blognone_example/ui/screens/node_content_screen.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

class NodeTitleListScreen extends StatefulWidget {
  final NodeTitleListMode mode;
  final String title;
  final String tag;

  NodeTitleListScreen({this.title = "Blognone", this.mode = NodeTitleListMode.ALL, this.tag = ""});

  @override
  _NodeTitleListScreenState createState() => _NodeTitleListScreenState();
}

class _NodeTitleListScreenState extends State<NodeTitleListScreen> with AutomaticKeepAliveClientMixin<NodeTitleListScreen> {
  int currentPage = 0;
  bool isLoadingMore = false;
  FlutterBlognone bn;
  List<BlognoneNodeTitleDao> listNode;

  @override
  void initState() {
    bn = FlutterBlognone();
    listNode = List();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: Container(
        child: FutureBuilder(
            future: loadNodeTitleList(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<BlognoneNodeTitleDao> list = snapshot.data;
                return LazyLoadScrollView(
                    onEndOfPage: () => loadMore(),
                    child: ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, i) {
                        return buildRowNodeTitle(list[i]);
                      },
                    ));
              } else {
                return Container();
              }
            }),
      ),
    );
  }

  Widget buildRowNodeTitle(BlognoneNodeTitleDao nodeTitle) {
    return GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => NodeContentScreen(nodeId: nodeTitle.id)));
        },
        child: Container(
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
              SizedBox(height: 8),
              Text("โดย " + nodeTitle.writer + " " + nodeTitle.date, style: TextStyle(fontSize: 12, color: Colors.grey[800])),
              buildTagsContainer(nodeTitle.tags),
              Text(
                nodeTitle.content,
                style: TextStyle(fontSize: 12, color: Colors.grey[700]),
              ),
              SizedBox(height: 12),
              Container(
                constraints: BoxConstraints.expand(height: 0.5),
                color: Colors.grey[400],
              ),
              SizedBox(height: 6),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Text(
                  "${nodeTitle.countComment} ความคิดเห็น",
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ])
            ],
          ),
        ));
  }

  buildTagsContainer(List<String> tags) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Wrap(spacing: 4, alignment: WrapAlignment.start, runAlignment: WrapAlignment.start, direction: Axis.horizontal, children: <Widget>[
        for (String tag in tags)
          GestureDetector(
            child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(border: Border.all(color: Colors.grey[300], width: 1)),
                child: Text(
                  tag,
                  style: TextStyle(fontSize: 12),
                )),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => NodeTitleListScreen(title: tag,mode: NodeTitleListMode.TAG, tag: tag)));
            },
          )
      ]),
    );
  }

  Future loadMore() async {
    if (!isLoadingMore) {
      isLoadingMore = true;
      List<BlognoneNodeTitleDao> list = await bn.fetchNodeTitleList(page: currentPage + 1);
      listNode.addAll(list);
      currentPage++;
      isLoadingMore = false;
    } else {
      //
    }

    setState(() {});
  }

  Future<List<BlognoneNodeTitleDao>> loadNodeTitleList() async {
    if (currentPage == 0 && listNode.isEmpty) {
      print("load node");
      if (widget.mode == NodeTitleListMode.ALL) {
        listNode = await bn.fetchNodeTitleList(page: currentPage);
      } else if (widget.mode == NodeTitleListMode.TAG) {
        listNode = await bn.fetchNodeTitleListByTag(tag: widget.tag, page: currentPage);
      } else if (widget.mode == NodeTitleListMode.FEATURE) {
        listNode = await bn.fetchNodeTitleListFeature(page: currentPage);
      } else if (widget.mode == NodeTitleListMode.INTERVIEW) {
        listNode = await bn.fetchNodeTitleListInterview(page: currentPage);
      } else if (widget.mode == NodeTitleListMode.WORKPLACE) {
        listNode = await bn.fetchNodeTitleListWorkPlace(page: currentPage);
      }
    }
    return listNode;
  }

  @override
  bool get wantKeepAlive => true;
}
