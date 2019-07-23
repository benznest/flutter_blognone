import 'dart:async';
import 'dart:convert';
import 'package:flutter_blognone/blognone_scraping.dart';
import 'package:flutter_blognone/dao/node_title_dao.dart';
import 'package:http/http.dart' as http;

class FlutterBlognone {
  static const String BASE_URL = "blognone.com";
  static const String POINT_API = "api/";

  /// Public API
  static const String END_POINT_NODE_LIST = "";

  FlutterBlognone();

  /// Get List all available symbols.
  Future<List<NodeTitleDao>> fetchNodeTitleList({bool printJson = false}) async {
    String url = Uri.https(BASE_URL, END_POINT_NODE_LIST).toString();
    var response = await http.get(url);
    List<NodeTitleDao> listNode = BlognoneScraping.scrapeNodeTitleList(utf8.decode(response.bodyBytes));
    if (printJson) {
      print(url);
    }
    return listNode;
  }
}
