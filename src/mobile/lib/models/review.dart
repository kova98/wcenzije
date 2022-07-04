class Review {
  final int id;
  final List<String> imageUrls;
  final String content;
  final int likeCount;

  Review(this.id, this.imageUrls, this.content, this.likeCount);

  Review.fromJson(Map<String, dynamic> parsedJson)
      : id = parsedJson['id'],
        imageUrls = parsedJson['imageUrls'].cast<String>(),
        content = parsedJson['content'],
        likeCount = parsedJson['likeCount'];

  Map<String, dynamic> toMap() => <String, dynamic>{
        "id": id,
        "imageUrls": imageUrls,
        "content": content,
        "likeCount": likeCount
      };
}
