import 'package:intl/intl.dart';

String getCurrentDate() {
  final now = DateTime.now();
  final formatter = DateFormat('dd-MM-yyyy');
  return formatter.format(now);
}