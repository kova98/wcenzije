import 'qualities.dart';

class Review {
  final int id;
  final List<String> imageUrls;
  final String content;
  final int likeCount;
  final int rating;
  final String location;
  final String name;
  final Gender gender;
  final Qualities qualities;
  final DateTime dateCreated;
  final DateTime? dateUpdated;
  final String? author;
  final bool isAnonymous;

  Review({
    required this.id,
    required this.imageUrls,
    required this.content,
    required this.likeCount,
    required this.location,
    required this.name,
    required this.rating,
    required this.gender,
    required this.qualities,
    required this.dateCreated,
    required this.isAnonymous,
    this.author,
    this.dateUpdated,
  });

  Review.fromJson(Map<String, dynamic> parsedJson)
      : id = parsedJson['id'],
        imageUrls = parsedJson['imageUrls']?.cast<String>() ?? [],
        content = parsedJson['content'] ?? "",
        likeCount = parsedJson['likeCount'] ?? 0,
        rating = parsedJson['rating'] ?? 0,
        location = parsedJson['location'] ?? "",
        name = parsedJson['name'] ?? "",
        gender = Gender.values[parsedJson['gender'] ?? 0],
        qualities = Qualities.fromJson(parsedJson['qualities'] ?? {}),
        dateCreated =
            DateTime.tryParse(parsedJson['dateCreated'] ?? "") ?? DateTime(0),
        dateUpdated = DateTime.tryParse(parsedJson['dateUpdated'] ?? ""),
        isAnonymous = parsedJson['isAnonymous'] ?? false,
        author = parsedJson['author'] ?? "";

  Map<String, dynamic> toMap() => <String, dynamic>{
        "id": id,
        "imageUrls": imageUrls,
        "content": content,
        "likeCount": likeCount,
        "location": location,
        "name": name,
        "rating": rating,
        "gender": gender.index,
        "qualities": qualities.toMap(),
        // "dateUpdated": dateUpdated.toString(),
        "dateCreated": dateCreated.toString(),
        "isAnonymous": isAnonymous
      };

  static String formatLocation(double lat, double lng) => "$lat,$lng";
}

enum Gender { unisex, male, female }
