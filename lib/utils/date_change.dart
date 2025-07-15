import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

bool smartDateOnChanged({
  required String value,
  required TextEditingController controller,
  required void Function(String) updatePreviousText,
  required String previousText,
}) {
  String digits = value.replaceAll(RegExp(r'[^0-9]'), '');
  String day = '', month = '', year = '';
  int len = digits.length;

  // Day
  if (len >= 1) {
    if (len >= 2) {
      int d = int.tryParse(digits.substring(0, 2)) ?? 0;
      if (d >= 1 && d <= 31) {
        day = digits.substring(0, 2);
      } else {
        int d1 = int.tryParse(digits[0]) ?? 0;
        if (d1 >= 4 && d1 <= 9) {
          day = '0${digits[0]}';
        } else {
          day = digits[0];
        }
      }
    } else {
      int d1 = int.tryParse(digits[0]) ?? 0;
      if (d1 >= 4 && d1 <= 9) {
        day = '0${digits[0]}';
      } else {
        day = digits[0];
      }
    }
  }

  // Month
  if (digits.length > day.length) {
    int start = day.length;
    if (digits.length >= start + 2) {
      int m = int.tryParse(digits.substring(start, start + 2)) ?? 0;
      if (m >= 1 && m <= 12) {
        month = digits.substring(start, start + 2);
      } else {
        int m1 = int.tryParse(digits[start]) ?? 0;
        if (m1 >= 2 && m1 <= 9) {
          month = '0${digits[start]}';
        } else {
          month = digits[start];
        }
      }
    } else if (digits.length == start + 1) {
      int m1 = int.tryParse(digits[start]) ?? 0;
      if (m1 >= 2 && m1 <= 9) {
        month = '0${digits[start]}';
      } else {
        month = digits[start];
      }
    }
  }

  // Year
  int yearStart = day.length + month.length;
  if (digits.length > yearStart) {
    year = digits.substring(yearStart);
    if (year.length > 4) {
      year = year.substring(0, 4);
    }
  }

  // Final format
  String formatted = '';
  if (day.isNotEmpty) {
    formatted += day;
    if (day.length == 2) formatted += '/';
  }
  if (month.isNotEmpty) {
    formatted += month;
    if (month.length == 2) formatted += '/';
  }
  if (year.isNotEmpty) {
    formatted += year;
  }

  if (value != formatted) {
    controller.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  updatePreviousText(formatted);

  // Return true only if the final value is a valid full date
  if (formatted.length == 10) {
    try {
      DateFormat('dd/MM/yyyy').parseStrict(formatted);
      return true;
    } catch (_) {
      return false;
    }
  }
  return false;
}

Future<void> selectDate(
  BuildContext context,
  TextEditingController controller,
) async {
  DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2000), // Start date
    lastDate: DateTime(2101), // End date
  );

  if (picked != null) {
    controller.text = DateFormat('dd/MM/yyyy').format(picked);
  }
}
