import 'package:flutter/material.dart';
import 'package:mobile/app/main.dart';
import 'package:mobile/base/theme/color.dart';

AppColors getColorSkin() {
  return Theme.of(navigatorKey.currentContext!).extension<AppColors>() ??
      AppColors.defaultInstance();
}

// TextStyleTheme getTypoSkin() {
//   return Theme.of(navigatorKey.currentContext!).extension<TextStyleTheme>() ?? TextStyleTheme.defaultInstance();
// }
