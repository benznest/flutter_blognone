import 'package:flutter_blognone/dao/blognone_node_comment_dao.dart';
import 'package:flutter_blognone/dao/blognone_node_comment_item_dao.dart';
import 'package:flutter_blognone/dao/blognone_node_content_dao.dart';
import 'package:flutter_blognone/dao/blognone_node_title_dao.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as html;

class BlognoneScraping {
  static List<BlognoneNodeTitleDao> scrapeNodeTitleList(String body) {
    List<BlognoneNodeTitleDao> listNode = List();

    var document = html.parse(body);
    var elementContainer = document.querySelector(".content-container");
    var elements = elementContainer.querySelectorAll("div[id^=node-]");
    for (var e in elements) {
      BlognoneNodeTitleDao node = BlognoneNodeTitleDao();

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
      listNode.add(node);
    }

    return listNode;
  }

  static BlognoneNodeContentDao scrapeNodeContent(String body) {
    Document document = html.parse(body);

    BlognoneNodeContentDao nodeContent = BlognoneNodeContentDao();

    Element elementNode = document.querySelector("div[id^=node-]");

    String strNodeId = elementNode.attributes["id"].split("-")[1];
    int nodeId = int.parse(strNodeId);
    nodeContent.id = nodeId;

    String urlImage = document.querySelector("div.node-image>img").attributes["src"];
    nodeContent.urlImage = urlImage;

    bool isSticky = elementNode.attributes["class"].contains("sticky");
    nodeContent.isSticky = isSticky;
    if (isSticky) {
      nodeContent.writer = "sponsored";
    }

    bool isWorkplace = elementNode.attributes["class"].contains("workplace");
    nodeContent.isWorkplaceNode = isWorkplace;

    List<Element> elementTag = elementNode.querySelector("span.terms-label").querySelectorAll(".field-item");
    List<String> listTag = List();
    for (Element et in elementTag) {
      String str = et.text.replaceAll("Tags", "").replaceAll("Topics", "").replaceAll("\u00A0", "").trim();
      if (str.isNotEmpty) {
        listTag.add(str);
      }
    }
    nodeContent.tags = listTag;

    String title = elementNode.querySelector("h2>a").text;
    nodeContent.title = title;

    String writer = elementNode.querySelector("span.username").text;
    nodeContent.writer = writer;

    Element nodeDate = elementNode.querySelector("span.submitted");
    nodeDate.querySelector("span.username")?.remove();
    nodeDate.querySelector("div.user_badges")?.remove();
    String strDate = nodeDate.text.replaceAll("By", "").replaceAll("on", "").replaceAll(":", "").trim();
    nodeContent.date = strDate;

    // get content
    Element elementContent = elementNode.querySelector("div.content");
    elementContent.querySelector("div.social-sharing")?.remove();
    String htmlBody = elementContent.innerHtml;

    htmlBody = "<div class=\"content\"  style=\"background:" + "" + "\">" + htmlBody + "</div>";
    nodeContent.contentFull = htmlBody;

    BlognoneNodeCommentDao comment = scrapeComment(body);
    nodeContent.comments = comment;

    return nodeContent;
  }

  static BlognoneNodeCommentDao scrapeComment(String body) {
    Document document = html.parse(body);
    Element elementCommentArea = document.querySelector("#comment-area");
    elementCommentArea.querySelector("h2")?.remove();
    elementCommentArea.querySelector("#comments");
    String htmlComment = elementCommentArea.innerHtml;

    BlognoneNodeCommentDao comment = BlognoneNodeCommentDao();
    comment.html = htmlComment;

    List<Element> listCommentElement = document.querySelectorAll("div[id^=cid-]");
    comment.countComment = listCommentElement.length;

    List<BlognoneNodeCommentItemDao> listComment = List();

    for (Element commentElement in listCommentElement) {
      BlognoneNodeCommentItemDao commentItem = scrapeCommentItem(commentElement);
      if (commentItem.isReplyComment) {
        for (int i = 0; i < listComment.length; i++) {
          listComment[i].addCommentItemIfTarget(commentItem);
        }
      } else {
        listComment.add(commentItem);
      }
    }

    comment.items = listComment;
    return comment;
  }

  static BlognoneNodeCommentItemDao scrapeCommentItem(Element commentElement) {
    BlognoneNodeCommentItemDao commentItem = BlognoneNodeCommentItemDao();

    commentItem.id = int.parse(commentElement.attributes["id"].replaceAll("cid-", ""));

    List<Element> listCommentTarget = commentElement.querySelectorAll(".comment-target");
    if (listCommentTarget.length > 1) {
      commentItem.replyTo = int.parse(listCommentTarget[1].text.replaceAll("Reply to:", ""));
    }

    Element commentContent = commentElement.querySelector("div.comment-content");
    commentItem.content = commentContent.innerHtml.replaceAll("\n", "").trim();

    try {
      commentItem.avatar = commentElement.querySelector("div.user-picture>img")?.attributes["src"];
    } catch (error) {
      //
    }

    commentItem.username = commentElement.querySelector(".username").text;

    Element commentInfoElement = commentElement.querySelector("div.comment-info");
    commentInfoElement.querySelector(".username")?.remove();
    commentItem.datetime = commentInfoElement.text.replaceAll("By:", "").replaceAll("\n", "").trim();
    return commentItem;
  }
}
