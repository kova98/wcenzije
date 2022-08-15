import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wcenzije/models/review.dart';

class ReviewScreen extends StatelessWidget {
  final Review review;
  late Color color;

  ReviewScreen(this.review) {
    color = determineColor(review.gender);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                  color: Colors.white,
                  iconSize: 26,
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.all(8)),
            title(),
            const Padding(padding: EdgeInsets.all(8)),
            ratingBar(),
            const Padding(padding: EdgeInsets.all(8)),
            qualities(),
            const Padding(padding: EdgeInsets.all(8)),
            imageDisplay(),
            const Padding(padding: EdgeInsets.all(8)),
            contentTextField(),
          ],
        ),
      ),
    );
  }

  UnderlineInputBorder coloredBorder() {
    return UnderlineInputBorder(
      borderSide: BorderSide(color: color),
    );
  }

  TextStyle whiteText() {
    return TextStyle(color: Colors.white);
  }

  Widget contentTextField() {
    return Card(
      color: Colors.white,
      child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            review.content,
            style: TextStyle(fontSize: 16),
          )),
    );
  }

  Widget title() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Center(
        child: Text(
          review.name,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget quality(icon, value, positiveMsg, negativeMsg) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(
            icon,
            color: value ? color : Colors.grey,
          ),
          const Padding(padding: EdgeInsets.all(8)),
          value
              ? Text(
                  positiveMsg,
                  style: TextStyle(color: color),
                )
              : Text(
                  negativeMsg,
                  style: TextStyle(color: Colors.grey),
                )
        ],
      ),
    );
  }

  Widget qualities() {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            quality(
              FontAwesomeIcons.hand,
              review.qualities.hasPaperTowels,
              "Ima papira za ruke!",
              "Nema papira za ruke.",
            ),
            quality(
              FontAwesomeIcons.toiletPaper,
              review.qualities.hasToiletPaper,
              "Ima WC papira!",
              "Nema WC papira.",
            ),
            quality(
              FontAwesomeIcons.soap,
              review.qualities.hasSoap,
              "Ima sapuna!",
              "Nema sapuna.",
            ),
            quality(
              FontAwesomeIcons.broom,
              review.qualities.isClean,
              "Čisto je!",
              "Prljavo je.",
            ),
          ],
        ),
      ),
    );
  }

  Widget imageDisplay() {
    return Card(
      child: Container(
        height: 300.0,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: review.imageUrls.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Container(
                child: Image.network(
                  review.imageUrls[index],
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget ratingBar() {
    return Center(
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(30),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              RatingBar.builder(
                ignoreGestures: true,
                glowColor: Colors.amber,
                initialRating: review.rating / 2,
                minRating: 0,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.white,
                ),
                onRatingUpdate: (value) {},
              ),
              const Padding(padding: EdgeInsets.all(4)),
            ],
          ),
        ),
      ),
    );
  }

  static Color determineColor(Gender gender) {
    switch (gender) {
      case Gender.male:
        return Colors.blue;
      case Gender.female:
        return Colors.pink;
      case Gender.unisex:
        return Colors.green;
    }
  }
}
