import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wcenzije/config.dart';
import 'package:wcenzije/models/review.dart';
import 'package:wcenzije/services/auth.dart';
import 'package:wcenzije/services/compressor.dart';

class ReviewsRepository {
  final String _root = "${Config().apiRoot}/review";
  final String _rootV2 = "${Config().apiRoot}/v2/review";
  final _authService = AuthService();
  final _compressorService = CompressorService();

  Future<List<Review>> getReviewsForMap() async {
    final response = await http.get(Uri.parse("$_rootV2/map"));

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch reviews');
    }

    final reviews = json.decode(response.body) as List;
    final reviewsList = reviews.map((item) => Review.fromJson(item)).toList();

    return reviewsList;
  }

  Future<List<Review>> getReviews(List<int> ids) async {
    final query = "?ids=${ids.join(",")}";
    final response = await http.get(Uri.parse(_rootV2 + query));

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch reviews');
    }

    final reviews = json.decode(response.body);
    final dynamicList = reviews["reviews"] as List;
    final reviewsList =
        dynamicList.map((item) => Review.fromJson(item)).toList();

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
      final compressed = await _compressorService.compressImage(image.path);
      var pic = await http.MultipartFile.fromPath("files", compressed);
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

  Future<List<Review>> getReviewsByAuthor(String author) async {
    final response = await http.get(
      Uri.parse("$_root/author/$author"),
      headers: await getHeaders(),
    );

    if (response.statusCode == 401) {
      _authService.logout();
      return [];
    }

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch reviews');
    }

    final reviews = json.decode(response.body) as List;
    final reviewsList = reviews.map((item) => Review.fromJson(item)).toList();

    return reviewsList;
  }

  Future<Review?> getReview(num reviewId) async {
    final response = await http.get(
      Uri.parse("$_root/$reviewId"),
      headers: await getHeaders(),
    );

    if (response.statusCode == 401) {
      _authService.logout();
      return null;
    }

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch review');
    }

    final review = Review.fromJson(json.decode(response.body));

    return review;
  }

  Future<Map<String, String>> getHeaders() async {
    var authToken = await _authService.getAuthToken();

    var headers = <String, String>{
      'Content-Type': 'application/json; charset=utf-8',
      'Authorization': 'Bearer $authToken'
    };

    return headers;
  }
}
