import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wcenzije/models/review.dart';
import 'package:wcenzije/screens/home.dart';
import 'package:wcenzije/services/reviews_repo.dart';

import '../../models/qualities.dart';
import '../../services/geolocator.dart';

class AddReviewContentScreen extends StatefulWidget {
  final String name;

  AddReviewContentScreen(this.name, {Key? key}) : super(key: key);

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
  bool hasPaperTowels = false;
  Gender gender = Gender.unisex;
  List<XFile> images = [];

  Color color = Colors.green;
  Color accentColor = Colors.greenAccent;

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: color,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Padding(padding: EdgeInsets.all(16)),
              title(),
              const Padding(padding: EdgeInsets.all(8)),
              ratingBar(),
              const Padding(padding: EdgeInsets.all(2)),
              genderToggleButton(),
              const Padding(padding: EdgeInsets.all(2)),
              qualities(),
              const Padding(padding: EdgeInsets.all(2)),
              contentTextField(),
              const Padding(padding: EdgeInsets.all(2)),
              imagePicker(),
              const Padding(padding: EdgeInsets.all(2)),
              submitButton(_formKey)
            ],
          ),
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
            labelStyle: TextStyle(color: color),
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
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            final pos = await determinePosition();
            final review = Review(
              id: 0,
              likeCount: 0,
              imageUrls: [],
              name: widget.name,
              content: contentText,
              location: Review.formatLocation(pos.latitude, pos.longitude),
              rating: (rating * 2).round(),
              gender: gender,
              qualities: Qualities(
                hasPaperTowels: hasPaperTowels,
                hasSoap: hasSoap,
                hasToiletPaper: hasToiletPaper,
                isClean: isClean,
              ),
            );

            showDialog(
              context: context,
              builder: (_) => Material(
                type: MaterialType.transparency,
                child: Scaffold(
                  backgroundColor: Colors.black.withAlpha(100),
                  body: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            );

            final response = await repo.createReview(review, images);

            if (response != 200) {
              Navigator.pop(context);
              const snackBar = SnackBar(
                content: Text('Došlo je do pogreške.'),
                backgroundColor: Colors.red,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            } else {
              Future.delayed(const Duration(seconds: 2), () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => HomeScreen()),
                    (route) => false);
              });

              showDialog(
                context: context,
                builder: (_) => const Material(
                  type: MaterialType.transparency,
                  child: Scaffold(
                    backgroundColor: Colors.blue,
                    body: Center(
                      child: Text(
                        'WCenzija objavljena!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
          }
        },
        child: Text(
          'Objavi',
          style: TextStyle(color: color),
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
          activeTrackColor: accentColor,
          activeColor: color,
          value: value,
          onChanged: (val) => setState(() {
            updateCallback(val);
          }),
        ),
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
              hasPaperTowels,
              "Ima papira za ruke!",
              "Nema papira za ruke.",
              (val) => hasPaperTowels = val,
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
                  color: color,
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

  // TODO: add this back in
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

  Color determineColor(Gender gender) {
    switch (gender) {
      case Gender.male:
        return Colors.blue;
      case Gender.female:
        return Colors.pink;
      case Gender.unisex:
        return Colors.green;
    }
  }

  Color determineAccentColor(Gender gender) {
    switch (gender) {
      case Gender.male:
        return Colors.blueAccent;
      case Gender.female:
        return Colors.pinkAccent;
      case Gender.unisex:
        return Colors.greenAccent;
    }
  }

  List<bool> isSelected = [false, true, false];

  genderToggleButton() {
    return Card(
      child: LayoutBuilder(
        builder: (context, constraints) => ToggleButtons(
          constraints: BoxConstraints.expand(
            width: constraints.maxWidth / 3 - 1.5,
            height: 50,
          ),
          selectedBorderColor: Colors.transparent,
          borderColor: Colors.transparent,
          children: const <Widget>[
            Icon(Icons.male, color: Colors.blue, size: 30),
            Icon(Icons.people, color: Colors.green, size: 30),
            Icon(Icons.female, color: Colors.pink, size: 30),
          ],
          onPressed: (int index) {
            setState(() {
              setSelected(index);
              setGender(index);
              setColor();
            });
          },
          isSelected: isSelected,
        ),
      ),
    );
  }

  void setColor() {
    color = determineColor(gender);
    accentColor = determineAccentColor(gender);
  }

  void setSelected(int index) {
    for (int i = 0; i < isSelected.length; i++) {
      if (i == index) {
        isSelected[i] = true;
      } else {
        isSelected[i] = false;
      }
    }
  }

  void setGender(int index) {
    switch (index) {
      case 0:
        gender = Gender.male;
        break;
      case 1:
        gender = Gender.unisex;
        break;
      case 2:
        gender = Gender.female;
    }
  }
}
