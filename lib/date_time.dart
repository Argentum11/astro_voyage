import 'package:intl/intl.dart';

String formatDateTime(String dateString) {
  DateTime dateTime = DateTime.parse(dateString);
  DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');
  return formatter.format(dateTime);
}