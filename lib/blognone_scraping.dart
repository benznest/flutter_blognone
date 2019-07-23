import 'package:flutter_blognone/dao/node_title_dao.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as html;

class BlognoneScraping {
  static List<NodeTitleDao> scrapeNodeTitleList(String body) {
    List<NodeTitleDao> listNode = List();

    var document = html.parse(body);
    var elementContainer = document.querySelector(".content-container");
    var elements = elementContainer.querySelectorAll("div[id^=node-]");
    for (var e in elements) {
      NodeTitleDao node = NodeTitleDao();

      // NODE ID
      String strNodeId = e.attributes["id"].split("-")[1];
      int nodeId = int.parse(strNodeId);
      node.id = nodeId;

      // WRITER
      String writer = e.querySelector("span.username").text;
      node.writer = writer;

      // DATE
      String nodeDate = e.querySelector("span.submitted").text.split("on")[1].trim();
      node.date = nodeDate;

      // STICKY
      bool isSticky = e.attributes["class"].contains("sticky");
      node.isSticky = isSticky;
      if (isSticky) {
        node.writer = "sponsored";
      }

      // WORKPLACE NODE
      bool isWorkplaceNode = e.attributes["class"].contains("workplace");
      node.isWorkplaceNode = isWorkplaceNode;

      // TAGS
      List<Element> elementTag = e.querySelector("span.terms-label").querySelectorAll(".field-item");
      List<String> tags = List();
      for (Element et in elementTag) {
        String str = et.text
            .replaceAll("Tags", "")
            .replaceAll("Topics", "")
//                            .replaceAll(":", "")
            .replaceAll("\u00A0", "")
            .trim();

        if (str.isNotEmpty) {
          tags.add(str);
        }
      }
      node.tags = tags;

      // TITLE
      String title = e.querySelector("h2>a").text;
      node.title = title;

      // IMAGE
      String urlImage = "";
      try {
        urlImage = e.querySelector("div.node-image>img").attributes["src"];
      } catch (er) {}
      node.urlImage = urlImage;

      // CONTENT
      String content = e.querySelector("div.node-content").text;
      node.content = content;

      // COUNT COMMENT
      int countComment = 0;
      try {
        String strCountComment = e.querySelector("li.comment-comments>a").text.split(" ")[0];
        countComment = int.parse(strCountComment);
      } catch (er) {}
      node.countComment = countComment;

      node.printLog();
      listNode.add(node);
    }

    return listNode;
  }
}
