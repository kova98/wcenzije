import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wcenzije/helpers/gender_helper.dart';
import 'package:wcenzije/models/review.dart';
import 'package:wcenzije/screens/add_review/where.dart';
import 'package:wcenzije/screens/home.dart';
import 'package:wcenzije/screens/login.dart';
import 'package:wcenzije/services/auth.dart';
import 'package:wcenzije/services/reviews_repo.dart';
import 'package:google_place/google_place.dart' hide Review;

import '../../models/qualities.dart';

class AddReviewContentScreen extends StatefulWidget {
  final String name;
  final String placeId;

  AddReviewContentScreen(this.name, this.placeId, {Key? key}) : super(key: key);

  @override
  State<AddReviewContentScreen> createState() => _AddReviewContentScreenState();
}

class _AddReviewContentScreenState extends State<AddReviewContentScreen> {
  final repo = ReviewsRepository();
  final authService = AuthService();

  bool ratingValid = true;
  String contentText = '';
  double rating = 2.5;
  bool hasToiletPaper = false;
  bool hasSoap = false;
  bool isClean = false;
  bool hasPaperTowels = false;
  bool isAnonymous = false;
  Gender gender = Gender.unisex;
  List<XFile> images = [];
  Color darkColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    darkColor = Theme.of(context).primaryColorDark;

    return Scaffold(
      backgroundColor: Colors.blue,
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
      borderSide: BorderSide(color: darkColor),
    );
  }

  TextStyle whiteText() {
    return const TextStyle(color: Colors.white);
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
            labelStyle: TextStyle(color: darkColor),
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
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () => submit(_formKey),
              child: Text(
                isAnonymous ? 'Objavi anonimno' : 'Objavi',
                style: TextStyle(color: darkColor),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
              ),
              child: Icon(
                FontAwesomeIcons.userSecret,
                color: isAnonymous ? darkColor : Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  isAnonymous = !isAnonymous;
                });
              },
            ),
          )
        ],
      ),
    );
  }

  Widget toggle(icon, value, positiveMsg, updateCallback) {
    return Row(
      children: [
        Switch(
          activeTrackColor: darkColor,
          activeColor: darkColor,
          value: value,
          onChanged: (val) => setState(() {
            updateCallback(val);
          }),
        ),
        Container(
          width: 30,
          child: FaIcon(
            icon,
            color: value ? darkColor : Colors.grey,
          ),
        ),
        const Padding(padding: EdgeInsets.all(8)),
        value
            ? Text(
                positiveMsg,
                style: TextStyle(color: darkColor),
              )
            : Text(
                positiveMsg,
                style: const TextStyle(color: Colors.grey),
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
            toggle(
              FontAwesomeIcons.hand,
              hasPaperTowels,
              "Ima papira za ruke.",
              (val) => hasPaperTowels = val,
            ),
            toggle(
              FontAwesomeIcons.toiletPaper,
              hasToiletPaper,
              "Ima WC papira.",
              (val) => hasToiletPaper = val,
            ),
            toggle(
              FontAwesomeIcons.soap,
              hasSoap,
              "Ima sapuna.",
              (val) => hasSoap = val,
            ),
            toggle(
              FontAwesomeIcons.broom,
              isClean,
              'Čisto je.',
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
                  color: darkColor,
                  size: 40,
                ),
                if (images.isEmpty) ...[
                  const Spacer(),
                  Text(
                    "Dodaj fotografije",
                    style: TextStyle(color: darkColor),
                  ),
                  const Spacer()
                ],
                ...imageCountText(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> imageCountText() {
    final text = 1 < images.length && images.length < 5
        ? "${images.length} fotografije odabrane"
        : "${images.length} fotografija odabrana";

    return images.length > 0
        ? [
            const Spacer(),
            Text(text, style: TextStyle(color: darkColor)),
            const Spacer()
          ]
        : [const Spacer()];
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
                glowColor: Colors.amber,
                initialRating: rating,
                minRating: 0,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.white,
                ),
                onRatingUpdate: (r) {
                  setState(() {
                    rating = r;
                    if (rating > 0) ratingValid = true;
                  });
                },
              ),
              const Padding(padding: EdgeInsets.all(4)),
              if (!ratingValid)
                const Text(
                  'Molim te ocijeni WC.',
                  style: TextStyle(color: Colors.white),
                ),
            ],
          ),
        ),
      ),
    );
  }

  List<bool> isSelected = [false, true, false];

  genderToggleButton() {
    return Card(
      child: LayoutBuilder(
        builder: (context, constraints) => ToggleButtons(
          constraints: BoxConstraints.expand(
            width: constraints.maxWidth / 3 - 1.5,
            height: 60,
          ),
          selectedBorderColor: Colors.transparent,
          borderColor: Colors.transparent,
          onPressed: (int index) {
            setState(() {
              setSelected(index);
              setGender(index);
            });
          },
          isSelected: isSelected,
          children: <Widget>[
            genderButton(0, Icons.male, 'muški'),
            genderButton(1, Icons.people, 'unisex'),
            genderButton(2, Icons.female, 'ženski'),
          ],
        ),
      ),
    );
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

  void submit(_formKey) async {
    if (_formKey.currentState!.validate()) {
      if (rating == 0) {
        setState(() {
          ratingValid = false;
        });
        return;
      }
      final api = GooglePlace("AIzaSyA58YfseNMaYTIGom5PglCb73FqyQCn62Y");
      final details = await api.details.get(widget.placeId);
      final location = details!.result!.geometry!.location!;
      final review = Review(
          dateCreated: DateTime.now(),
          id: 0,
          likeCount: 0,
          imageUrls: [],
          name: widget.name,
          content: contentText,
          location: Review.formatLocation(location.lat!, location.lng!),
          rating: (rating * 2).round(),
          gender: gender,
          qualities: Qualities(
            hasPaperTowels: hasPaperTowels,
            hasSoap: hasSoap,
            hasToiletPaper: hasToiletPaper,
            isClean: isClean,
          ),
          isAnonymous: isAnonymous);

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

      if (response == 401) {
        await authService.logout();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(AddReviewWhereScreen()),
          ),
        );
        return;
      }

      if (response != 200) {
        Navigator.pop(context);
        const snackBar = SnackBar(
          content: Text('Došlo je do pogreške.'),
          backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
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
  }

  genderButton(int index, IconData icon, String title) {
    var selected = isSelected[index];
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: selected ? darkColor : Colors.grey, size: 30),
        Text(
          title,
          style: TextStyle(color: selected ? darkColor : Colors.grey),
        ),
      ],
    );
  }
}
