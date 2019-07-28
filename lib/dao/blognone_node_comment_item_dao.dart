class BlognoneNodeCommentItemDao {
  int id;
  String content;
  String username;
  String datetime;
  String avatar;
  int replyTo;

  List<BlognoneNodeCommentItemDao> items;

  BlognoneNodeCommentItemDao({this.content}) {
    items = List();
  }

  get isReplyComment => replyTo != null;
  get hasReply => items.isNotEmpty;

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "replyTo": this.replyTo,
      "content": this.content,
      "username": this.username,
      "datetime": this.datetime,
      "avatar": avatar,
      "items": items?.map((item) => item.toJson())?.toList()
    };
  }

  bool addCommentItemIfTarget(BlognoneNodeCommentItemDao item) {
    if(id == item.replyTo){
      items.add(item);
      return true;
    }else {
      for (int i = 0; i < items.length; i++) {
        bool isFound = items[i].addCommentItemIfTarget(item);
        if(isFound){
          return true;
        }
      }
    }
    return false;
  }
}
