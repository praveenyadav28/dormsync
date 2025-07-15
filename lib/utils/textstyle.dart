import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StyleText {
  TextStyle merriweatherText(double size, FontWeight weight, color) {
    return GoogleFonts.merriweather(
      fontSize: size,
      fontWeight: weight,
      color: color,
    );
  }
  TextStyle abhayaLibreText(double size, FontWeight weight, color) {
    return GoogleFonts.abhayaLibre(
      fontSize: size,
      fontWeight: weight,
      color: color,
    );
  }
}