import 'package:intl/intl.dart';

const shortDateFormat = "dd.MM.yyyy.";

String shortDate(DateTime date) => DateFormat(shortDateFormat).format(date);
