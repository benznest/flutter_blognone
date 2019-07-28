import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_blognone/blognone_scraping.dart';
import 'package:flutter_blognone/blognone_utils.dart';
import 'package:flutter_blognone/dao/blognone_node_content_dao.dart';
import 'package:flutter_blognone/dao/blognone_node_title_dao.dart';
import 'package:http/http.dart' as http;

class FlutterBlognone {
  static const String BASE_URL = "blognone.com";

  /// Public API
  static const String END_POINT_NODE_LIST = "node";
  static const String END_POINT_NODE_LIST_TAG = "topics/";
  static const String END_POINT_NODE_LIST_FEATURE = "feature";
  static const String END_POINT_NODE_CONTENT = "node/";

  FlutterBlognone();

  /// Get List all title nodes on blognone home page.
  Future<List<BlognoneNodeTitleDao>> fetchNodeTitleList({int page = 0, bool printJson = false}) async {
    String url = Uri.https(BASE_URL, END_POINT_NODE_LIST, {"page": "$page"}).toString();
    var response = await http.get(url);
    List<BlognoneNodeTitleDao> listNode = BlognoneScraping.scrapeNodeTitleList(utf8.decode(response.bodyBytes));
    if (printJson) {
      printPrettyJsonList(listNode.map((item) => item.toJson()).toList());
    }
    return listNode;
  }

  /// Get List all node title about tag..
  Future<List<BlognoneNodeTitleDao>> fetchNodeTitleListByTag({String tag = "games", int page = 0, bool printJson = false}) async {
    tag = tag.replaceAll(" ", "-");
    String url = Uri.https(BASE_URL, END_POINT_NODE_LIST_TAG + tag, {"page": "$page"}).toString();
    var response = await http.get(url);
    List<BlognoneNodeTitleDao> listNode = BlognoneScraping.scrapeNodeTitleList(utf8.decode(response.bodyBytes));
    if (printJson) {
      printPrettyJsonList(listNode.map((item) => item.toJson()).toList());
    }
    return listNode;
  }

  /// Get List all node title about tag..
  Future<List<BlognoneNodeTitleDao>> fetchNodeTitleListFeature({ int page = 0, bool printJson = false}) async {

    String url = Uri.https(BASE_URL, END_POINT_NODE_LIST_FEATURE, {"page": "$page"}).toString();
    var response = await http.get(url);
    List<BlognoneNodeTitleDao> listNode = BlognoneScraping.scrapeNodeTitleList(utf8.decode(response.bodyBytes));
    if (printJson) {
      printPrettyJsonList(listNode.map((item) => item.toJson()).toList());
    }
    return listNode;
  }

  /// Get List all node title about interview node.
  Future<List<BlognoneNodeTitleDao>> fetchNodeTitleListInterview({int page = 0, bool printJson = false}) async {
    return fetchNodeTitleListByTag(tag: "interview",page: page,printJson: printJson);
  }

  /// Get List all node title about blognone workplace node.
  Future<List<BlognoneNodeTitleDao>> fetchNodeTitleListWorkPlace({int page = 0, bool printJson = false}) async {
    return fetchNodeTitleListByTag(tag: "blognone-workplace",page: page,printJson: printJson);
  }

  /// Get content in node.
  Future<BlognoneNodeContentDao> fetchNodeContentList({@required int nodeId, bool printJson = false}) async {
    String url = Uri.https(BASE_URL, END_POINT_NODE_CONTENT + "$nodeId").toString();
    var response = await http.get(url);
    BlognoneNodeContentDao nodeContent = BlognoneScraping.scrapeNodeContent(utf8.decode(response.bodyBytes));
    if (printJson) {
      printPrettyJson(nodeContent.toJson());
    }

    return nodeContent;
  }
}
