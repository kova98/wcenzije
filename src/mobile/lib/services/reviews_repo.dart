import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wcenzije/config.dart';
import 'package:wcenzije/models/review.dart';
import 'package:wcenzije/services/auth.dart';

class ReviewsRepository {
  final String _root = "${Config().apiRoot}/review";
  final _authService = AuthService();

  Future<List<Review>> getReviews() async {
    final response = await http.get(Uri.parse(_root));

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch reviews');
    }

    final reviews = json.decode(response.body) as List;
    final reviewsList = reviews.map((item) => Review.fromJson(item)).toList();

    return reviewsList;
  }

  Future<int> createReview(Review review, List<XFile> images) async {
    var authToken = await _authService.getAuthToken();
    if (authToken == null) {
      return 401;
    }

    var createResponse = await _createReview(review, authToken);

    if (createResponse.statusCode != 201) {
      return createResponse.statusCode;
    }

    var reviewUri = createResponse.headers["location"];
    var request = http.MultipartRequest("POST", Uri.parse("$reviewUri/images"));
    request.headers.addAll({
      'Content-Type': 'application/json; charset=utf-8',
      'Authorization': 'Bearer $authToken'
    });

    for (var image in images) {
      var pic = await http.MultipartFile.fromPath("files", image.path);
      request.files.add(pic);
    }

    var response = await request.send();
    return response.statusCode;
  }

  Future<Response> _createReview(Review review, String authToken) async {
    var headers = <String, String>{
      'Content-Type': 'application/json; charset=utf-8',
      'Authorization': 'Bearer $authToken'
    };

    var reviewJson = json.encode(review.toMap());

    var reviewResponse = await http.post(
      Uri.parse(_root),
      headers: headers,
      body: reviewJson,
    );

    return reviewResponse;
  }
}
