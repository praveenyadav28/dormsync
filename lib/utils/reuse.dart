import 'package:flutter/material.dart';

tableHeader(text) {
  return TableCell(
    child: Padding(
      padding: const EdgeInsets.all(4),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
    ),
  );
}

tableBody(text) {
  return TableCell(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(text, textAlign: TextAlign.center),
    ),
  );
}
