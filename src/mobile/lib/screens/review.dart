import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:wcenzije/helpers/date_helper.dart';
import 'package:wcenzije/helpers/gender_helper.dart';
import 'package:wcenzije/models/review.dart';
import 'package:photo_view/photo_view.dart';

class ReviewScreen extends StatefulWidget {
  final Review review;
  late Color color;

  ReviewScreen(this.review) {
    color = review.gender.color();
  }

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  int _currentPage = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.color,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
            ...nameAndDate(),
            const Padding(padding: EdgeInsets.all(8)),
            qualities(),
            const Padding(padding: EdgeInsets.all(4)),
            widget.review.imageUrls.isNotEmpty
                ? imageDisplay()
                : const SizedBox.shrink(),
            const Padding(padding: EdgeInsets.all(4)),
            contentTextField(),
            const Padding(padding: EdgeInsets.all(8)),
          ],
        ),
      ),
    );
  }

  UnderlineInputBorder coloredBorder() {
    return UnderlineInputBorder(
      borderSide: BorderSide(color: widget.color),
    );
  }

  List<Widget> nameAndDate() {
    return [
      const Center(
        child: Text(
          'anonimni korisnik',
          style: TextStyle(color: Colors.white),
        ),
      ),
      const Padding(padding: EdgeInsets.all(2)),
      Center(
        child: Text(
          shortDate(widget.review.dateCreated),
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
            widget.review.content,
            style: const TextStyle(fontSize: 16),
          )),
    );
  }

  Widget title() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Center(
        child: Text(
          widget.review.name,
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
            color: value ? widget.color : Colors.grey,
          ),
          const Padding(padding: EdgeInsets.all(8)),
          value
              ? Text(
                  positiveMsg,
                  style: TextStyle(color: widget.color),
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
              widget.review.qualities.hasPaperTowels,
              "Ima papira za ruke!",
              "Nema papira za ruke.",
            ),
            quality(
              FontAwesomeIcons.toiletPaper,
              widget.review.qualities.hasToiletPaper,
              "Ima WC papira!",
              "Nema WC papira.",
            ),
            quality(
              FontAwesomeIcons.soap,
              widget.review.qualities.hasSoap,
              "Ima sapuna!",
              "Nema sapuna.",
            ),
            quality(
              FontAwesomeIcons.broom,
              widget.review.qualities.isClean,
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
                  backgroundDecoration: BoxDecoration(color: Colors.white),
                  scrollPhysics: const BouncingScrollPhysics(),
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index + 1;
                    });
                  },
                  builder: (BuildContext context, int index) {
                    return PhotoViewGalleryPageOptions(
                      imageProvider:
                          NetworkImage(widget.review.imageUrls[index]),
                      initialScale: PhotoViewComputedScale.covered * 0.95,
                      heroAttributes: PhotoViewHeroAttributes(tag: index),
                    );
                  },
                  itemCount: widget.review.imageUrls.length,
                  loadingBuilder: (context, event) => Center(
                    child: Container(
                      width: 20.0,
                      height: 20.0,
                      child: CircularProgressIndicator(
                        value: event == null
                            ? 0
                            : event.cumulativeBytesLoaded /
                                (event.expectedTotalBytes ?? 1),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Text(
                          '$_currentPage/${widget.review.imageUrls.length}',
                          style: TextStyle(color: Colors.white, fontSize: 12),
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
            )),
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
                initialRating: widget.review.rating / 2,
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
}
