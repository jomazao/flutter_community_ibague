import 'package:intl/intl.dart';

extension DateExtensions on DateTime {
  String dayMonthYear() {
    return DateFormat('dd/MM/yyyy').format(this);
  }
}
