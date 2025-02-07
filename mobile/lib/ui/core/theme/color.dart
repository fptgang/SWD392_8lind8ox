import 'package:flutter/material.dart';

class AppColors extends ThemeExtension<AppColors> {

  //text
  final Color textColor;

  final Color backgroundColor;

  final Color primaryColor;

  final Color secondaryColor;

  final Color accentColor;

  /// Brown - #a88969
  final Color brown;

  /// Primary color - #F4F6F8
  final Color primary;

  /// Secondary color - #202935
  final Color secondary;

  /// Accent color - #366AE2
  final Color accent;

  /// Light blue - #4D7AE5
  final Color lightBlue;

  /// Light blue 200 - #DEE7FA
  final Color lightBlue200;

  /// Dark blue - #1F40AD
  final Color darkBlue;

  /// White - #FFFFFF
  final Color white;

  /// White transparent - #00FFFFFF
  final Color whiteTransparent;

  /// Light cyan - #AFE2FF
  final Color lightCyan;

  /// Light yellow - #FCF7E2
  final Color lightYellow;

  /// Dark grey - #212B36
  final Color darkGrey;

  /// Grey - #919EAB
  final Color grey;

  /// Light grey - #F2F3F5
  final Color lightGrey;

  /// Light grey 300 - #E0E0E0
  final Color lightGrey300;

  /// Light grey 400 - #E8ECEF
  final Color lightGrey400;

  /// Light grey 500 - #E9ECEE
  final Color lightGrey500;

  /// Light grey 600 - #DCE1E6
  final Color lightGrey600;

  /// Light grey 700 - #D0D6DD
  final Color lightGrey700;

  /// Medium grey - #707E8B
  final Color mediumGrey;

  /// Dark neutral grey - #63696C
  final Color darkNeutralGrey;

  /// Warning red - #FF5630
  final Color warningRed;

  /// Deep green - #118D57
  final Color deepGreen;

  /// Light green 100 - #F0FFF4
  final Color lightGreen100;

  /// Transparent - #00000000
  final Color transparent;

  /// Black - #000000
  final Color black;

  /// Deep blue - #1F40AD
  final Color deepBlue;

  /// Light shadow - #33919EAB
  final Color shadowLight;

  /// Dark shadow - #1F919EAB
  final Color shadowDark;

  /// Pale blue - #DFE7FA
  final Color paleBlue;

  /// Border grey - #E5E8EB
  final Color borderGrey;

  /// Neutral grey - #637381
  final Color neutralGrey;

  /// Bright orange - #FFAB00
  final Color brightOrange;

  /// Success green - #22C55E
  final Color successGreen;

  /// Error red - #F44336
  final Color errorRed;

  /// Light orange - #FFE9D5
  final Color lightOrange;

  /// Light orange 100 - #FFF8EB
  final Color lightOrange100;

  /// Light pink - #FFCDD2
  final Color lightPink;

  /// Light grey 200 - #EEEEEE
  final Color lightGrey200;

  /// Light grey 100 - #F5F5F5
  final Color lightGrey100;

  /// Red - #FF4842
  final Color red;

  /// Dark red - #B71C1C
  final Color darkRed;

  /// Light red - #FFCDD2
  final Color lightRed;

  /// Black with 87% opacity - #DD000000
  final Color black87;

  /// Black with 54% opacity - #8A000000
  final Color black54;

  /// Black with 38% opacity - #61000000
  final Color black38;

  /// Orange background - #F6F7F8
  final Color orangeBackground;

  /// Grey outline - #EDEFF2
  final Color greyOutline;

  /// Background white - #FBFCFC
  final Color backgroundWhite;

  /// Highlight yellow - #EAC993
  final Color highlightYellow;

  /// Pale yellow - #F9FAFB
  final Color paleYellow;

  /// Soft blue - #EFF3FE
  final Color softBlue;

  final Color blue;
  final Color green;
  final Color orange;
  final Color yellow;
  final Color deepPurple;

  /// Yellow 700 - #FBC02D
  final Color yellow700;

  /// Mint Green - #EDFAF2
  final Color mintGreen;

  /// Light grey 800 - #F5F6F8
  final Color lightGrey800;

  /// Light blue 100 - #BFCFF6
  final Color lightBlue100;

  /// Grayish teal - #A7B1BC
  final Color grayishTeal;

  //bce4b3
  final Color lightGreen;

  //f9f5ec
  final Color lightBrown;

  //fec107
  final Color boldYellow;

  /// Primary Red
  final Color primaryRed50;
  final Color primaryRed100;
  final Color primaryRed200;
  final Color primaryRed300;
  final Color primaryRed400;
  final Color primaryRed500;
  final Color primaryRed550;
  final Color primaryRed600;
  final Color primaryRed650;
  final Color primaryRed700;
  final Color primaryRed800;
  final Color primaryRed900;
  final Color primaryRed950;

  /// Secondary Blue
  final Color secondaryBlue50;
  final Color secondaryBlue100;
  final Color secondaryBlue200;
  final Color secondaryBlue300;
  final Color secondaryBlue400;
  final Color secondaryBlue500;
  final Color secondaryBlue600;
  final Color secondaryBlue700;
  final Color secondaryBlue800;
  final Color secondaryBlue900;

  /// Tertiary Green
  final Color tertiaryGreen50;
  final Color tertiaryGreen100;
  final Color tertiaryGreen200;
  final Color tertiaryGreen300;
  final Color tertiaryGreen400;
  final Color tertiaryGreen500;
  final Color tertiaryGreen600;
  final Color tertiaryGreen700;
  final Color tertiaryGreen800;
  final Color tertiaryGreen900;

  AppColors({
    required this.textColor,
    required this.backgroundColor,
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    required this.brown,
    required this.primary,
    required this.secondary,
    required this.accent,
    required this.lightBlue,
    required this.lightBlue200,
    required this.darkBlue,
    required this.white,
    required this.whiteTransparent,
    required this.lightCyan,
    required this.lightYellow,
    required this.darkGrey,
    required this.grey,
    required this.lightGrey,
    required this.lightGrey300,
    required this.lightGrey400,
    required this.lightGrey500,
    required this.lightGrey600,
    required this.lightGrey700,
    required this.mediumGrey,
    required this.darkNeutralGrey,
    required this.warningRed,
    required this.deepGreen,
    required this.lightGreen100,
    required this.transparent,
    required this.black,
    required this.deepBlue,
    required this.shadowLight,
    required this.shadowDark,
    required this.paleBlue,
    required this.borderGrey,
    required this.neutralGrey,
    required this.brightOrange,
    required this.successGreen,
    required this.errorRed,
    required this.lightOrange,
    required this.lightOrange100,
    required this.lightPink,
    required this.lightGrey200,
    required this.lightGrey100,
    required this.red,
    required this.darkRed,
    required this.lightRed,
    required this.black87,
    required this.black54,
    required this.black38,
    required this.orangeBackground,
    required this.greyOutline,
    required this.backgroundWhite,
    required this.highlightYellow,
    required this.paleYellow,
    required this.softBlue,
    required this.blue,
    required this.green,
    required this.orange,
    required this.yellow,
    required this.deepPurple,
    required this.yellow700,
    required this.mintGreen,
    required this.lightGrey800,
    required this.lightBlue100,
    required this.grayishTeal,
    required this.lightGreen,
    required this.lightBrown,
    required this.boldYellow,
    required this.primaryRed50,
    required this.primaryRed100,
    required this.primaryRed200,
    required this.primaryRed300,
    required this.primaryRed400,
    required this.primaryRed500,
    required this.primaryRed550,
    required this.primaryRed600,
    required this.primaryRed650,
    required this.primaryRed700,
    required this.primaryRed800,
    required this.primaryRed900,
    required this.primaryRed950,
    required this.secondaryBlue50,
    required this.secondaryBlue100,
    required this.secondaryBlue200,
    required this.secondaryBlue300,
    required this.secondaryBlue400,
    required this.secondaryBlue500,
    required this.secondaryBlue600,
    required this.secondaryBlue700,
    required this.secondaryBlue800,
    required this.secondaryBlue900,
    required this.tertiaryGreen50,
    required this.tertiaryGreen100,
    required this.tertiaryGreen200,
    required this.tertiaryGreen300,
    required this.tertiaryGreen400,
    required this.tertiaryGreen500,
    required this.tertiaryGreen600,
    required this.tertiaryGreen700,
    required this.tertiaryGreen800,
    required this.tertiaryGreen900,
  });

  static AppColors defaultInstance() {
    return AppColors(
      textColor: const Color(0xFF0c0407),
      backgroundColor: const Color(0xFFFFFFFF),
      primaryColor: const Color(0xFFc39d99),
      secondaryColor: const Color(0xFFdbab9e),
      accentColor: const Color(0xFFcfa27c),
      brown: const Color(0xFFa88969),
      primary: const Color(0xFFF4F6F8),
      secondary: const Color(0xFF202935),
      accent: const Color(0xFF366AE2),
      lightBlue: const Color(0xFF4D7AE5),
      lightBlue200: const Color(0xFFDEE7FA),
      darkBlue: const Color(0xFF1F40AD),
      white: const Color(0xFFFFFFFF),
      whiteTransparent: const Color(0x00FFFFFF),
      lightCyan: const Color(0xFFAFE2FF),
      lightYellow: const Color(0xFFFCF7E2),
      darkGrey: const Color(0xFF212B36),
      grey: const Color(0xFF919EAB),
      lightGrey: const Color(0xFFF2F3F5),
      lightGrey300: const Color(0xFFE0E0E0),
      lightGrey400: const Color(0xFFE8ECEF),
      lightGrey500: const Color(0xFFE9ECEE),
      lightGrey600: const Color(0xFFDCE1E6),
      lightGrey700: const Color(0xFFD0D6DD),
      mediumGrey: const Color(0xFF707E8B),
      darkNeutralGrey: const Color(0xFF63696C),
      warningRed: const Color(0xFFFF5630),
      deepGreen: const Color(0xFF118D57),
      lightGreen100: const Color(0xFFF0FFF4),
      transparent: const Color(0x00000000),
      black: const Color(0xFF000000),
      deepBlue: const Color(0xFF1F40AD),
      shadowLight: const Color(0x33919EAB),
      shadowDark: const Color(0x1F919EAB),
      paleBlue: const Color(0xFFDFE7FA),
      borderGrey: const Color(0xFFE5E8EB),
      neutralGrey: const Color(0xFF637381),
      brightOrange: const Color(0xFFFFAB00),
      successGreen: const Color(0xFF22C55E),
      errorRed: const Color(0xFFF44336),
      lightOrange: const Color(0xFFFFE9D5),
      lightOrange100: const Color(0xFFFFF8EB),
      lightPink: const Color(0xFFFFCDD2),
      lightGrey200: const Color(0xFFEEEEEE),
      lightGrey100: const Color(0xFFF5F5F5),
      red: const Color(0xFFFF4842),
      darkRed: const Color(0xFFB71C1C),
      lightRed: const Color(0xFFFFCDD2),
      black87: const Color(0xDD000000),
      black54: const Color(0x8A000000),
      black38: const Color(0x61000000),
      orangeBackground: const Color(0xFFF6F7F8),
      greyOutline: const Color(0xFFEDEFF2),
      backgroundWhite: const Color(0xFFFBFCFC),
      highlightYellow: const Color(0xFFEAC993),
      paleYellow: const Color(0xFFF9FAFB),
      softBlue: const Color(0xFFEFF3FE),
      blue: Colors.blue,
      green: Colors.green,
      orange: Colors.orange,
      yellow: Colors.yellow,
      deepPurple: Colors.deepPurple,
      yellow700: const Color(0xFFFBC02D),
      mintGreen: const Color(0xFFEDFAF2),
      lightGrey800: const Color(0xFFF5F6F8),
      lightBlue100: const Color(0xFFBFCFF6),
      grayishTeal: const Color(0xFFA7B1BC),
      lightGreen: const Color(0xFFbce4b3),
      lightBrown: const Color(0xFFf9f5ec),
      boldYellow: const Color(0xFFfec107),
      primaryRed50: const Color(0xFFFDF3F3),
      primaryRed100: const Color(0xFFFDE3E3),
      primaryRed200: const Color(0xFFFCCCCC),
      primaryRed300: const Color(0xFFF8A9A9),
      primaryRed400: const Color(0xFFF27777),
      primaryRed500: const Color(0xFFE74C4C),
      primaryRed550: const Color(0xFFff0000),
      primaryRed600: const Color(0xFFd70000),
      primaryRed650: const Color(0xFFC62B2B),
      primaryRed700: const Color(0xFFB22323),
      primaryRed800: const Color(0xFF932121),
      primaryRed900: const Color(0xFF7B2121),
      primaryRed950: const Color(0xFF500000),
      secondaryBlue50: const Color(0xFFF1F6FD),
      secondaryBlue100: const Color(0xFFDFECFA),
      secondaryBlue200: const Color(0xFFC5DEF8),
      secondaryBlue300: const Color(0xFF9EC9F2),
      secondaryBlue400: const Color(0xFF70ACEA),
      secondaryBlue500: const Color(0xFF4E8DE3),
      secondaryBlue600: const Color(0xFF3971D7),
      secondaryBlue700: const Color(0xFF2F5BC1),
      secondaryBlue800: const Color(0xFF2D4DA0),
      secondaryBlue900: const Color(0xFF29427F),
      tertiaryGreen50:  const Color(0xFFF4FBF2),
      tertiaryGreen100: const Color(0xFFE6F6E2),
      tertiaryGreen200: const Color(0xFFCDECC6),
      tertiaryGreen300: const Color(0xFFA6DB9A),
      tertiaryGreen400: const Color(0xFF75C26C),
      tertiaryGreen500: const Color(0xFF4FAB52),
      tertiaryGreen600: const Color(0xFF346C29),
      tertiaryGreen700: const Color(0xFF3C5625),
      tertiaryGreen800: const Color(0xFF264720),
      tertiaryGreen900: const Color(0xFF10260D),
    );
  }

  @override
  ThemeExtension<AppColors> copyWith() {
    throw UnimplementedError();
  }

  @override
  ThemeExtension<AppColors> lerp(covariant ThemeExtension<AppColors>? other, double t) {
    throw UnimplementedError();
  }
}
