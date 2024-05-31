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
  final num reviewId;

  const ReviewScreen(this.reviewId, {Key? key}) : super(key: key);

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final repo = ReviewsRepository();
  int _currentPage = 1;
  late Review _review;
  @override
  Widget build(BuildContext context) {
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
        _review = snapshot.data!;

        return Scaffold(
          backgroundColor: Colors.blue,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView(
              children: [
                navBar(),
                const Padding(padding: EdgeInsets.all(8)),
                title(),
                const Padding(padding: EdgeInsets.all(8)),
                ratingBar(),
                ...nameAndDate(),
                const Padding(padding: EdgeInsets.all(8)),
                qualities(),
                const Padding(padding: EdgeInsets.all(4)),
                _review.imageUrls.isNotEmpty
                    ? imageDisplay()
                    : const SizedBox.shrink(),
                const Padding(padding: EdgeInsets.all(4)),
                contentTextField(),
                const Padding(padding: EdgeInsets.all(8)),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> nameAndDate() {
    return [
      Center(
        child: Text(
          _review.author ?? "anonimni korisnik",
          style: const TextStyle(color: Colors.white),
        ),
      ),
      const Padding(padding: EdgeInsets.all(2)),
      Center(
        child: Text(
          shortDate(_review.dateCreated),
          style: const TextStyle(color: Colors.white70),
        ),
      ),
    ];
  }

  Widget whiteText(String text) {
    return Text(text, style: const TextStyle(color: Colors.white));
  }

  Widget contentTextField() {
    return Card(
      color: Colors.white,
      child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            _review.content,
            style: const TextStyle(fontSize: 16),
          )),
    );
  }

  Widget title() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Center(
        child: Text(
          _review.name,
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
                  style: TextStyle(color: Colors.blue),
                )
              : Text(
                  negativeMsg,
                  style: const TextStyle(color: Colors.grey),
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
              _review.qualities.hasPaperTowels,
              "Ima papira za ruke!",
              "Nema papira za ruke.",
            ),
            quality(
              FontAwesomeIcons.toiletPaper,
              _review.qualities.hasToiletPaper,
              "Ima WC papira!",
              "Nema WC papira.",
            ),
            quality(
              FontAwesomeIcons.soap,
              _review.qualities.hasSoap,
              "Ima sapuna!",
              "Nema sapuna.",
            ),
            quality(
              FontAwesomeIcons.broom,
              _review.qualities.isClean,
              "Čisto je!",
              "Prljavo je.",
            ),
          ],
        ),
      ),
    );
  }

  Widget imageDisplay() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
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
                        CachedNetworkImageProvider(_review.imageUrls[index]),
                    initialScale: PhotoViewComputedScale.covered * 0.95,
                    heroAttributes: PhotoViewHeroAttributes(tag: index),
                  );
                },
                itemCount: _review.imageUrls.length,
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
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Text(
                        '$_currentPage/${_review.imageUrls.length}',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(18),
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
                initialRating: _review.rating / 2,
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
