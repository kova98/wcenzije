import 'package:flutter/material.dart';
import 'package:wcenzije/models/review.dart';

extension GenderHelpers on Gender {
  Color color() {
    switch (this) {
      case Gender.male:
        return Colors.blue;
      case Gender.female:
        return Colors.pink;
      case Gender.unisex:
        return Colors.green;
    }
  }

  Color accentColor() {
    switch (this) {
      case Gender.male:
        return Colors.blueAccent;
      case Gender.female:
        return Colors.pinkAccent;
      case Gender.unisex:
        return Colors.greenAccent;
    }
  }

  IconData icon() {
    switch (this) {
      case Gender.male:
        return Icons.male;
      case Gender.female:
        return Icons.female;
      case Gender.unisex:
        return Icons.people;
    }
  }
}
