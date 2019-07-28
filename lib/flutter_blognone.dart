import 'dart:async';
import 'dart:convert';
import 'package:flutter_blognone/blognone_scraping.dart';
import 'package:flutter_blognone/blognone_utils.dart';
import 'package:flutter_blognone/dao/blognone_node_content_dao.dart';
import 'package:flutter_blognone/dao/blognone_node_title_dao.dart';
import 'package:http/http.dart' as http;

class FlutterBlognone {
  static const String BASE_URL = "blognone.com";

  /// Public API
  static const String END_POINT_NODE_LIST = "node";
  static const String END_POINT_NODE_CONTENT = "node/";

  FlutterBlognone();

  /// Get List all ntitle odes on blognone home page.
  Future<List<BlognoneNodeTitleDao>> fetchNodeTitleList({int page = 0, bool printJson = false}) async {
    String url = Uri.https(BASE_URL, END_POINT_NODE_LIST).toString();
    var response = await http.get(url + "?page=$page");
    List<BlognoneNodeTitleDao> listNode = BlognoneScraping.scrapeNodeTitleList(utf8.decode(response.bodyBytes));
    if (printJson) {
      printPrettyJsonList(listNode.map((item) => item.toJson()).toList());
    }
    return listNode;
  }

  /// Get content in node.
  Future<BlognoneNodeContentDao> fetchNodeContentList({int nodeId = 110985, bool printJson = false}) async {
    String url = Uri.https(BASE_URL, END_POINT_NODE_CONTENT + "$nodeId").toString();
    var response = await http.get(url);
    BlognoneNodeContentDao nodeContent = BlognoneScraping.scrapeNodeContent(utf8.decode(response.bodyBytes));
    if (printJson) {
      printPrettyJson(nodeContent.toJson());
    }
    return nodeContent;
  }
}
