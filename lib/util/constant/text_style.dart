import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uzayprojesi/util/constant/colors.dart';

class SbtTextStyle {
  static var appbarText = GoogleFonts.kalam(
      textStyle: TextStyle(
          color: SbtColor.anaRenk, fontSize: 16, fontWeight: FontWeight.bold));
  static var textfildBaslik = GoogleFonts.kalam(
      textStyle: TextStyle(
          color: SbtColor.anaRenk, fontSize: 20, fontWeight: FontWeight.bold));
  static var textfildBaslikMini = GoogleFonts.kalam(
      textStyle: TextStyle(
          color: SbtColor.yaziRenk, fontSize: 16, fontWeight: FontWeight.bold));
  static var tx2 = GoogleFonts.kalam(
      textStyle: TextStyle(color: SbtColor.yaziRenk, fontSize: 18));
  static var tx3 = GoogleFonts.kalam(
      textStyle: TextStyle(color: SbtColor.yaziRenk, fontSize: 20));

  static var miniStyle = GoogleFonts.roboto(
      textStyle: TextStyle(color: SbtColor.yaziRenk, fontSize: 12));
  static var midiumStyle = GoogleFonts.roboto(
      textStyle: TextStyle(color: SbtColor.yaziRenk, fontSize: 13));
}
