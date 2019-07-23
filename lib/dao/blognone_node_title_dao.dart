class BlognoneNodeTitleDao {
  int id;
  String urlImage;
  String title;
  String content;
  String date;
  String writer;
  List<String> tags;
  bool isSticky;
  bool isWorkplaceNode;
  int countComment;

  printLog() {
    print("nodeId = $id");
    print("writer = $writer");
    print("nodeDate = $date");
    print("eSticky = $isSticky");
    print("eWorkplace = $isWorkplaceNode");
    for (String tag in tags) {
      print("tag = $tag");
    }
    print("title = $title");
    print("urlImage = $urlImage");
    print("info = $content");
    print("strCountComment = $countComment");
    print("----------------------");
  }

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "urlImage": this.urlImage,
      "title": this.title,
      "content": this.content,
      "date": this.date,
      "writer": this.writer,
      "tags": this.tags,
      "isSticky": this.isSticky,
      "isWorkplaceNode": this.isWorkplaceNode,
      "countComment": this.countComment,
    };
  }


}
