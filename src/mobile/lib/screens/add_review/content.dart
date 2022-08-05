import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

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
                const Padding(padding: EdgeInsets.all(16)),
                necessities(),
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

  Text title() {
    return Text(
      widget.name,
      style: const TextStyle(
          color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
    );
  }

  Widget submitButton(GlobalKey<FormState> _formKey) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Processing Data')),
            );
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

  Widget necessity(icon, value, positiveMsg, negativeMsg, updateCallback) {
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

  Widget necessities() {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            necessity(
              FontAwesomeIcons.hand,
              hasPaperTowel,
              "Ima papira za ruke!",
              "Nema papira za ruke.",
              (val) => hasPaperTowel = val,
            ),
            necessity(
              FontAwesomeIcons.toiletPaper,
              hasToiletPaper,
              "Ima WC papira!",
              "Nema WC papira.",
              (val) => hasToiletPaper = val,
            ),
            necessity(
              FontAwesomeIcons.soap,
              hasSoap,
              "Ima sapuna!",
              "Nema sapuna.",
              (val) => hasSoap = val,
            ),
            necessity(
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
}
