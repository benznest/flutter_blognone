class NodeTitleDao {
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
}
