class Review {
  final int id;
  final List<String> imageUrls;
  final String content;
  final int likeCount;
  final int rating;
  final String location;
  final String name;

  Review(this.id, this.imageUrls, this.content, this.likeCount, this.location,
      this.name, this.rating);

  Review.fromJson(Map<String, dynamic> parsedJson)
      : id = parsedJson['id'],
        imageUrls = parsedJson['imageUrls'].cast<String>(),
        content = parsedJson['content'],
        likeCount = parsedJson['likeCount'] ?? 0,
        rating = parsedJson['rating'] ?? 0,
        location = parsedJson['location'] ?? "",
        name = parsedJson['name'] ?? "";

  Map<String, dynamic> toMap() => <String, dynamic>{
        "id": id,
        "imageUrls": imageUrls,
        "content": content,
        "likeCount": likeCount,
        "location": location,
        "name": name,
        "rating": rating
      };
}
