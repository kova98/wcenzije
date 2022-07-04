import 'dart:convert';

import 'package:http/http.dart' as http;
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
}
