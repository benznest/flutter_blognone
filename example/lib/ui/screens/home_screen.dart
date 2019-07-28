import 'package:flutter/material.dart';
import 'package:flutter_blognone/dao/blognone_node_title_dao.dart';
import 'package:flutter_blognone/flutter_blognone.dart';
import 'package:flutter_blognone_example/node_title_list_mode.dart';
import 'package:flutter_blognone_example/ui/screens/node_content_screen.dart';
import 'package:flutter_blognone_example/ui/screens/node_title_list_screen.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen();

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin  {
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 4);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(controller: _tabController, children: [
        NodeTitleListScreen(
          mode: NodeTitleListMode.ALL,
        ),
        NodeTitleListScreen(title: "FEATURE",
          mode: NodeTitleListMode.FEATURE,
        ),
        NodeTitleListScreen(title: "INTERVIEW",
          mode: NodeTitleListMode.INTERVIEW,
        ),
        NodeTitleListScreen(title: "WORKPLACE",
          mode: NodeTitleListMode.WORKPLACE,
        ),
      ]),
      bottomNavigationBar: TabBar(controller: _tabController, labelColor: Colors.blue, unselectedLabelColor: Colors.grey[400], tabs: [
        Tab(text: "Home"),
        Tab(text: "Feature"),
        Tab(text: "Interview"),
        Tab(text: "Workplace"),
      ]),
    );
  }

}
