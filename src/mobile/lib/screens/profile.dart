import 'package:flutter/material.dart';
import 'package:wcenzije/helpers/gender_helper.dart';
import 'package:wcenzije/models/review.dart';
import 'package:wcenzije/screens/review.dart';
import 'package:wcenzije/services/auth.dart';
import 'package:wcenzije/services/reviews_repo.dart';

import '../helpers/date_helper.dart';
import 'home.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);

  final _authService = AuthService();
  final _repo = ReviewsRepository();

  Future<ProfileData> _getProfileData() async {
    final userName = await _authService.getUsername();
    final reviews = await _repo.getReviewsByAuthor(userName ?? "as");

    return ProfileData(userName ?? "as", reviews);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ProfileData>(
      future: _getProfileData(),
      builder: (context, snapshot) {
        return snapshot.hasData
            ? Scaffold(
                appBar: AppBar(title: Text(snapshot.data!.userName), actions: [
                  IconButton(
                      onPressed: () async {
                        await _authService.logout();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => HomeScreen()),
                            (route) => false);
                      },
                      icon: Icon(Icons.logout))
                ]),
                body: snapshot.data!.reviews.isEmpty
                    ? const Center(
                        child: Text(
                          'Nemaš objavljenih wcenzija.',
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ListView.builder(
                        itemCount: snapshot.data!.reviews.length,
                        itemBuilder: (context, index) => InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReviewScreen(
                                reviewId: snapshot.data!.reviews[index].id,
                              ),
                            ),
                          ),
                          child: Card(
                            child: ListTile(
                              title: Text(snapshot.data!.reviews[index].name),
                              subtitle: Text(shortDate(
                                  snapshot.data!.reviews[index].dateCreated)),
                              leading: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    snapshot.data!.reviews[index].gender.icon(),
                                    color: snapshot.data!.reviews[index].gender
                                        .color(),
                                    size: 32,
                                  ),
                                ],
                              ),
                              trailing: Text(
                                  "${snapshot.data!.reviews[index].rating}/10"),
                            ),
                          ),
                        ),
                      ))
            : Center(child: CircularProgressIndicator());
      },
    );
  }
}

class ProfileData {
  String userName;
  List<Review> reviews;

  ProfileData(this.userName, this.reviews);
}
