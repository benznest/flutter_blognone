class BlognoneNodeCommentItemDao {
  int id;
  String html;
  String username;
  String datetime;
  String avatar;
  int replyTo;

  List<BlognoneNodeCommentItemDao> items;

  BlognoneNodeCommentItemDao({this.html}) {
    items = List();
  }

  get isReplyComment => replyTo != null;

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "replyTo": this.replyTo,
      "html": this.html,
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
