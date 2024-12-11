import 'package:flutter/material.dart';

class DatePickerUtil {
  static Future<DateTime?> pickDate(BuildContext context) {
    return showDatePicker(
      context: context,
      initialDate: DateTime(1990),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
  }
}
