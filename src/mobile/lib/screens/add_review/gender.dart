import 'package:flutter/material.dart';

import '../../models/review.dart';
import 'content.dart';

class AddReviewGenderScreen extends StatefulWidget {
  final String name;
  const AddReviewGenderScreen(this.name, {Key? key}) : super(key: key);

  @override
  State<AddReviewGenderScreen> createState() => _AddReviewGenderScreenState();
}

class _AddReviewGenderScreenState extends State<AddReviewGenderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.blue, textStyle: TextStyle(fontSize: 12)),
                  onPressed: () => pushContentScreen(context, Gender.male),
                  child: const Icon(
                    Icons.male,
                    size: 200,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.all(6)),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.pink,
                    textStyle: TextStyle(fontSize: 12),
                  ),
                  onPressed: () => pushContentScreen(context, Gender.female),
                  child: const Icon(
                    Icons.female,
                    size: 200,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  pushContentScreen(context, gender) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddReviewContentScreen(gender, widget.name),
        ),
      );
}
