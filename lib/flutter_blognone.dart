import 'dart:async';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as html;
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

class FlutterBlognone {
  static const String BASE_URL = "blognone.com";
  static const String POINT_API = "api/";

  /// Public API
  static const String END_POINT_NODE_LIST = "";

  static const String END_POINT_MARKET_SYMBOLS = "market/symbols/";
  static const String END_POINT_MARKET_TICKER = "market/ticker/";
  static const String END_POINT_MARKET_RECENT_TRADE = "market/trades/";
  static const String END_POINT_OPEN_ORDER_BIDS = "market/bids/";
  static const String END_POINT_OPEN_ORDER_ASKS = "market/asks/";
  static const String END_POINT_OPEN_ORDER_ALL = "market/books/";

  FlutterBlognone();

  /// Get List all available symbols.
  Future fetchNodeList({bool printJson = false}) async {
    String url = Uri.https(BASE_URL, END_POINT_NODE_LIST).toString();
    var response = await http.get(url);

    var document = html.parse(response.body);
    var elementContainer = document.querySelector(".content-container");
    var elements = elementContainer.querySelectorAll("div[id^=node-]");
    for (var e in elements) {
      String strNodeId = e.attributes["id"].split("-")[1];
      int nodeId = int.parse(strNodeId);
      String writer = e.querySelector("span.username").text;
      String nodeDate = e.querySelector("span.submitted").text.split("on")[1].trim();

      bool eSticky = e.attributes["class"].contains("sticky");
      if (eSticky) {
//        node.setSticky(true);
//        node.setWriter("sponsored");
      }

      bool eWorkplace = e.attributes["class"].contains("workplace");
      if (eWorkplace) {
//        node.setWorkplace(true);
      }

      List<Element> elementTag = e.querySelector("span.terms-label").querySelectorAll(".field-item");
      List<String> listTag = List();
      for (Element et in elementTag) {
        String str = et.text
            .replaceAll("Tags", "")
            .replaceAll("Topics", "")
//                            .replaceAll(":", "")
            .replaceAll("\u00A0", "")
            .trim();

        if (str.isNotEmpty) {
          listTag.add(str);
        }
      }

      String title = e.querySelector("h2>a").text;
      String urlImage = "";
      try {
        urlImage = e.querySelector("div.node-image>img").attributes["src"];
      } catch (er) {}

      String info = e.querySelector("div.node-content").text;

      String strCountComment;
      try {
        strCountComment = e.querySelector("li.comment-comments>a").text.split(" ")[0];
      } catch (er) {}

      print("nodeId = $nodeId");
      print("writer = $writer");
      print("nodeDate = $nodeDate");
      print("eSticky = $eSticky");
      print("eWorkplace = $eWorkplace");
      for (String tag in listTag) {
        print("tag = $tag");
      }
      print("title = $title");
      print("urlImage = $urlImage");
      print("info = $info");
      print("strCountComment = $strCountComment");
      print("----------------------");
    }

//    BitkubMarketSymbolDao marketSymbols = BitkubMarketSymbolDao.fromJson(responseJson);

    if (printJson) {
      print(url);
    }
  }
}
