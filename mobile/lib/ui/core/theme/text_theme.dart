import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextStyleTheme extends ThemeExtension<TextStyleTheme> {
  /// Font size 10
  final TextStyle labelSmallestBold;

  /// Font size 12
  final TextStyle labelSmallRegular;
  final TextStyle labelSmallMedium;
  final TextStyle labelSmallBold;

  /// Font size 13
  final TextStyle labelMediumMedium;
  final TextStyle labelMediumBold;

  /// Font size 14
  final TextStyle bodySmallRegular;
  final TextStyle bodySmallMedium;
  final TextStyle bodySmallSemibold;
  final TextStyle bodySmallBold;

  /// Font size 15
  final TextStyle bodyMediumRegular;
  final TextStyle bodyMediumMedium;
  final TextStyle bodyMediumSemibold;
  final TextStyle bodyMediumBold;

  /// Font size 16
  final TextStyle bodyLargeRegular;
  final TextStyle bodyLargeMedium;
  final TextStyle bodyLargeSemibold;
  final TextStyle bodyLargeBold;

  /// Font size 17
  final TextStyle headingSmallBold;

  /// Font size 18
  final TextStyle headingMediumMedium;
  final TextStyle headingMediumBold;

  /// Font size 19
  final TextStyle headingLargeBold;

  /// Font size 20
  final TextStyle headingExtraLargeBold;

  TextStyleTheme({
    required this.labelSmallestBold,
    required this.labelSmallRegular,
    required this.labelSmallMedium,
    required this.labelSmallBold,
    required this.labelMediumMedium,
    required this.labelMediumBold,
    required this.bodySmallRegular,
    required this.bodySmallMedium,
    required this.bodySmallSemibold,
    required this.bodySmallBold,
    required this.bodyMediumRegular,
    required this.bodyMediumMedium,
    required this.bodyMediumSemibold,
    required this.bodyMediumBold,
    required this.bodyLargeRegular,
    required this.bodyLargeMedium,
    required this.bodyLargeSemibold,
    required this.bodyLargeBold,
    required this.headingSmallBold,
    required this.headingMediumMedium,
    required this.headingMediumBold,
    required this.headingLargeBold,
    required this.headingExtraLargeBold,
  });

  static TextStyleTheme defaultInstance() {
    return TextStyleTheme(
      // Font size 10
      labelSmallestBold: GoogleFonts.publicSans(fontSize: 10, fontWeight: FontWeight.bold),

      // Font size 12
      labelSmallRegular: GoogleFonts.publicSans(fontSize: 12, fontWeight: FontWeight.w400),
      labelSmallMedium: GoogleFonts.publicSans(fontSize: 12, fontWeight: FontWeight.w500),
      labelSmallBold: GoogleFonts.publicSans(fontSize: 12, fontWeight: FontWeight.w700),

      // Font size 13
      labelMediumMedium: GoogleFonts.publicSans(fontSize: 13, fontWeight: FontWeight.w500),
      labelMediumBold: GoogleFonts.publicSans(fontSize: 13, fontWeight: FontWeight.w700),

      // Font size 14
      bodySmallRegular: GoogleFonts.publicSans(fontSize: 14, fontWeight: FontWeight.w400),
      bodySmallMedium: GoogleFonts.publicSans(fontSize: 14, fontWeight: FontWeight.w500),
      bodySmallSemibold: GoogleFonts.publicSans(fontSize: 14, fontWeight: FontWeight.w600),
      bodySmallBold: GoogleFonts.publicSans(fontSize: 14, fontWeight: FontWeight.w700),

      // Font size 15
      bodyMediumRegular: GoogleFonts.publicSans(fontSize: 15, fontWeight: FontWeight.w400),
      bodyMediumMedium: GoogleFonts.publicSans(fontSize: 15, fontWeight: FontWeight.w500),
      bodyMediumSemibold: GoogleFonts.publicSans(fontSize: 15, fontWeight: FontWeight.w600),
      bodyMediumBold: GoogleFonts.publicSans(fontSize: 15, fontWeight: FontWeight.w700),

      // Font size 16
      bodyLargeRegular: GoogleFonts.publicSans(fontSize: 16, fontWeight: FontWeight.w400),
      bodyLargeMedium: GoogleFonts.publicSans(fontSize: 16, fontWeight: FontWeight.w500),
      bodyLargeSemibold: GoogleFonts.publicSans(fontSize: 16, fontWeight: FontWeight.w600),
      bodyLargeBold: GoogleFonts.publicSans(fontSize: 16, fontWeight: FontWeight.w700),

      // Font size 17
      headingSmallBold: GoogleFonts.publicSans(fontSize: 17, fontWeight: FontWeight.w700),

      // Font size 18
      headingMediumMedium: GoogleFonts.publicSans(fontSize: 18, fontWeight: FontWeight.w500),
      headingMediumBold: GoogleFonts.publicSans(fontSize: 18, fontWeight: FontWeight.w700),

      // Font size 19
      headingLargeBold: GoogleFonts.publicSans(fontSize: 19, fontWeight: FontWeight.w700),

      // Font size 20
      headingExtraLargeBold: GoogleFonts.publicSans(fontSize: 20, fontWeight: FontWeight.w700),
    );
  }

  @override
  ThemeExtension<TextStyleTheme> lerp(covariant ThemeExtension<TextStyleTheme>? other, double t) {
    throw UnimplementedError();
  }

  @override
  ThemeExtension<TextStyleTheme> copyWith() {
    throw UnimplementedError();
  }
}
