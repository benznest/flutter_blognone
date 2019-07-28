import 'package:flutter_blognone/dao/blognone_node_comment_item_dao.dart';

class BlognoneNodeCommentDao {
  String html;
  int countComment;
  List<BlognoneNodeCommentItemDao> items;

  BlognoneNodeCommentDao({this.html, this.countComment});

  Map<String, dynamic> toJson() {
    return {"html": this.html, "countComment": this.countComment, "items": items.map((item) => item.toJson()).toList()};
  }
}
