import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:wcenzije/helpers/date_helper.dart';
import 'package:wcenzije/helpers/gender_helper.dart';
import 'package:wcenzije/models/review.dart';
import 'package:photo_view/photo_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:wcenzije/services/reviews_repo.dart';

class ReviewScreen extends StatefulWidget {
  final int reviewId;
  final Review? review;

  const ReviewScreen({this.reviewId = 0, this.review, Key? key})
      : super(key: key);

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final repo = ReviewsRepository();

  int _currentPage = 1;

  @override
  Widget build(BuildContext context) {
    if (widget.review != null) {
      return reviewDisplay(widget.review!);
    }

    return FutureBuilder<Review?>(
      future: repo.getReview(widget.reviewId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: Colors.blue,
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  navBar(),
                  const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return reviewDisplay(snapshot.data!);
      },
    );
  }

  Scaffold reviewDisplay(Review review) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          children: [
            navBar(),
            const Padding(padding: EdgeInsets.all(8)),
            title(review),
            const Padding(padding: EdgeInsets.all(8)),
            ratingBar(review),
            Icon(review.gender.icon(), color: Colors.white, size: 32),
            const Padding(padding: EdgeInsets.all(8)),
            nameAndDate(review),
            const Padding(padding: EdgeInsets.all(8)),
            qualities(review),
            const Padding(padding: EdgeInsets.all(4)),
            review.imageUrls.isNotEmpty
                ? imageDisplay(review)
                : const SizedBox.shrink(),
            const Padding(padding: EdgeInsets.all(4)),
            contentTextField(review),
            const Padding(padding: EdgeInsets.all(8)),
          ],
        ),
      ),
    );
  }

  Widget nameAndDate(Review review) {
    return Column(
      children: [
        Text(
          (review.author ?? "") != "" ? review.author! : "anonimni korisnik",
          style: const TextStyle(color: Colors.white),
        ),
        const Padding(padding: EdgeInsets.all(2)),
        Text(
          shortDate(review.dateCreated),
          style: const TextStyle(color: Colors.white70),
        ),
      ],
    );
  }

  Widget whiteText(String text) {
    return Text(text, style: const TextStyle(color: Colors.white));
  }

  Widget contentTextField(Review review) {
    return Card(
      color: Colors.white,
      child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            review.content,
            style: const TextStyle(fontSize: 16),
          )),
    );
  }

  Widget title(Review review) {
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
            color: value ? Colors.blue : Colors.grey,
          ),
          const Padding(padding: EdgeInsets.all(8)),
          value
              ? Text(
                  positiveMsg,
                  style: const TextStyle(color: Colors.blue),
                )
              : Text(
                  negativeMsg,
                  style: const TextStyle(color: Colors.grey),
                )
        ],
      ),
    );
  }

  Widget qualities(Review review) {
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

  Widget imageDisplay(Review review) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: SizedBox(
          height: 300,
          child: Stack(
            children: [
              PhotoViewGallery.builder(
                backgroundDecoration: const BoxDecoration(color: Colors.white),
                scrollPhysics: const BouncingScrollPhysics(),
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index + 1;
                  });
                },
                builder: (BuildContext context, int index) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider:
                        CachedNetworkImageProvider(review.imageUrls[index]),
                    initialScale: PhotoViewComputedScale.covered * 0.95,
                    heroAttributes: PhotoViewHeroAttributes(tag: index),
                  );
                },
                itemCount: review.imageUrls.length,
                loadingBuilder: (context, event) => const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Text(
                        '$_currentPage/${review.imageUrls.length}',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget ratingBar(Review review) {
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

  Widget navBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          iconSize: 26,
        ),
      ],
    );
  }
}
