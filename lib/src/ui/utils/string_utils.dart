import 'package:intl/intl.dart';

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }

  String firstLetterInCapitalize() => this[0].toUpperCase() + substring(1);

  DateTime convertToDate() {
    DateTime date = DateFormat('dd/MM/yyyy hh:mm a').parse(this);
    return date;
  }

  DateTime convertDMYToDate() {
    DateTime date = DateFormat('dd/MM/yyyy').parse(this);
    return date;
  }
}
