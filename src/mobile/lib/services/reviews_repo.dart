import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:wcenzije/models/review.dart';

class ReviewsRepository {
  final String _root = "http://10.0.2.2:5085/api/review";

  Future<List<Review>> getReviews() async {
    final response = await http.get(Uri.parse(_root));

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch reviews');
    }

    final reviews = json.decode(response.body) as List;
    final reviewsList = reviews.map((item) => Review.fromJson(item)).toList();

    return reviewsList;
  }

  void createReview(Review review, List<XFile> images) async {
    final reviewUri = await _createReview(review);

    var request = http.MultipartRequest("POST", Uri.parse("$reviewUri/images"));

    for (var image in images) {
      var pic = await http.MultipartFile.fromPath("files", image.path);
      request.files.add(pic);
    }

    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    print(responseString);
  }

  Future<String> _createReview(Review review) async {
    var headers = <String, String>{
      'Content-Type': 'application/json; charset=utf-8',
    };

    var reviewJson = json.encode(review.toMap());

    var reviewResponse = await http.post(
      Uri.parse(_root),
      headers: headers,
      body: reviewJson,
    );

    if (reviewResponse.statusCode != 201) {
      throw Exception("Unable to create review.");
    }

    return reviewResponse.headers["location"]!;
  }
}
