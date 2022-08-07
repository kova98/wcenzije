import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wcenzije/models/review.dart';
import 'package:wcenzije/services/reviews_repo.dart';

class AddReviewContentScreen extends StatefulWidget {
  final String gender;
  final String name;
  final Color color;
  final Color accentColor;

  const AddReviewContentScreen(this.gender, this.name, {Key? key})
      : color = gender == 'female' ? Colors.pink : Colors.blue,
        accentColor =
            gender == 'female' ? Colors.pinkAccent : Colors.blueAccent,
        super(key: key);

  @override
  State<AddReviewContentScreen> createState() => _AddReviewContentScreenState();
}

class _AddReviewContentScreenState extends State<AddReviewContentScreen> {
  final repo = ReviewsRepository();

  String contentText = '';
  double rating = 2.5;
  bool hasToiletPaper = false;
  bool hasSoap = false;
  bool isClean = false;
  bool hasPaperTowel = false;
  List<XFile> images = [];

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: widget.color,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const Padding(padding: EdgeInsets.all(16)),
                title(),
                const Padding(padding: EdgeInsets.all(8)),
                ratingBar(),
                const Padding(padding: EdgeInsets.all(8)),
                qualities(),
                const Padding(padding: EdgeInsets.all(8)),
                contentTextField(),
                const Padding(padding: EdgeInsets.all(8)),
                imagePicker(),
                const Padding(padding: EdgeInsets.all(8)),
                submitButton(_formKey)
              ],
            ),
          ),
        ),
      ),
    );
  }

  UnderlineInputBorder coloredBorder() {
    return UnderlineInputBorder(
      borderSide: BorderSide(color: widget.color),
    );
  }

  TextStyle whiteText() {
    return TextStyle(color: Colors.white);
  }

  String? contentValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Molim te napiši osvrt';
    }
    return null;
  }

  Widget contentTextField() {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
        child: TextFormField(
          initialValue: contentText,
          onChanged: (value) => contentText = value,
          minLines: 1,
          maxLines: 5,
          // The validator receives the text that the user has entered.
          validator: contentValidator,
          decoration: InputDecoration(
            labelText: 'Osvrt',
            labelStyle: TextStyle(color: widget.color),
            focusedBorder: coloredBorder(),
          ),
        ),
      ),
    );
  }

  Widget title() {
    return Center(
      child: Text(
        widget.name,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget submitButton(GlobalKey<FormState> _formKey) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ElevatedButton(
        onPressed: () {
          print('submit button pressed');
          if (_formKey.currentState!.validate()) {
            double lat = 45.80895723907695;
            double lng = 15.97063830900707;

            final review = Review(
              id: 0,
              likeCount: 0,
              imageUrls: [],
              name: widget.name,
              content: contentText,
              location: Review.formatLocation(lat, lng),
              rating: (rating * 2).round(),
            );

            repo.createReview(review, images);
          }
        },
        child: Text(
          'Objavi',
          style: TextStyle(color: widget.color),
        ),
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
        ),
      ),
    );
  }

  Widget quality(icon, value, positiveMsg, negativeMsg, updateCallback) {
    return Row(
      children: [
        Switch(
          activeTrackColor: widget.accentColor,
          activeColor: widget.color,
          value: value,
          onChanged: (val) => setState(() {
            updateCallback(val);
          }),
        ),
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
                style: TextStyle(color: Colors.grey),
              )
      ],
    );
  }

  Widget qualities() {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            quality(
              FontAwesomeIcons.hand,
              hasPaperTowel,
              "Ima papira za ruke!",
              "Nema papira za ruke.",
              (val) => hasPaperTowel = val,
            ),
            quality(
              FontAwesomeIcons.toiletPaper,
              hasToiletPaper,
              "Ima WC papira!",
              "Nema WC papira.",
              (val) => hasToiletPaper = val,
            ),
            quality(
              FontAwesomeIcons.soap,
              hasSoap,
              "Ima sapuna!",
              "Nema sapuna.",
              (val) => hasSoap = val,
            ),
            quality(
              FontAwesomeIcons.broom,
              isClean,
              'Čisto je!',
              'Prljavo je.',
              (val) => isClean = val,
            ),
          ],
        ),
      ),
    );
  }

  Widget imagePicker() {
    return Card(
      child: InkWell(
        onTap: () async {
          final ImagePicker _picker = ImagePicker();
          final picked = await _picker.pickMultiImage() ?? [];
          setState(() {
            images = picked;
          });
        },
        child: Container(
          height: 100.0,
          child: Center(
            child: Column(
              children: [
                const Spacer(),
                Icon(
                  Icons.collections,
                  color: widget.color,
                  size: 40,
                ),
                ...imageCountText(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget imageDisplay() {
    return Card(
      child: Container(
        height: 100.0,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: images.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Container(
                width: 100,
                child: Image.file(
                  File(images[index].path),
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> imageCountText() {
    final text = 1 < images.length && images.length < 5
        ? "${images.length} fotografije odabrane"
        : "${images.length} fotografija odabrana";

    return images.length > 0
        ? [const Spacer(), Text(text), const Spacer()]
        : [const Spacer()];
  }

  Widget ratingBar() {
    return Center(
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(30),
        // elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              RatingBar.builder(
                glowColor: Colors.amber,
                initialRating: rating,
                minRating: 0,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.white,
                ),
                onRatingUpdate: (r) {
                  setState(() {
                    rating = r;
                  });
                },
              ),
              Padding(padding: EdgeInsets.all(4)),
              Text(
                'Tvoja ocjena: ${(rating * 2).round()}/10',
                style: whiteText(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
