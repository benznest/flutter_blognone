class BlognoneNodeContentDao {
  int id;
  String title;
  String urlImage;
  String contentFull;
  String writer;
  String date;
  bool isSticky;
  bool isWorkplaceNode;
  List<String> tags;

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "title": this.title,
      "urlImage": this.urlImage,
      "contentFull": this.contentFull,
      "writer": this.writer,
      "date": this.date,
      "isSticky": this.isSticky,
      "isWorkplaceNode": this.isWorkplaceNode,
      "tags": (this.tags.map((item) => item).toString()),
    };
  }
}
