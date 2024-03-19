import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uzayprojesi/util/constant/colors.dart';

class SbtTema {
  static var temam = ThemeData(
    iconTheme: IconThemeData(color: SbtColor.anaRenk),
    appBarTheme: AppBarTheme(
      backgroundColor: SbtColor.anaRenk,
      iconTheme: IconThemeData(color: SbtColor.yaziRenk),
      actionsIconTheme: IconThemeData(color: SbtColor.yaziRenk),
      titleTextStyle: GoogleFonts.dancingScript(
        textStyle: TextStyle(
          color: SbtColor.yaziRenk,
          fontSize: 28,
          fontWeight: FontWeight.w500,
        ),
      ),
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: SbtColor.yaziRenk,
      ),
    ),
    drawerTheme: const DrawerThemeData(shadowColor: Colors.red),
    scaffoldBackgroundColor: SbtColor.anaRenk,
  );
}
