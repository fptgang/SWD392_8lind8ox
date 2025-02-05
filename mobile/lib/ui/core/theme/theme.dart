

import 'package:mobile/main.dart';
import 'package:mobile/ui/core/theme/color.dart';
import 'package:mobile/ui/core/theme/text_theme.dart';
import 'package:flutter/material.dart';

AppColors getColorSkin() {
  return Theme.of(navigatorKey.currentContext!).extension<AppColors>() ?? AppColors.defaultInstance();
}

// TextStyleTheme getTypoSkin() {
//   return Theme.of(navigatorKey.currentContext!).extension<TextStyleTheme>() ?? TextStyleTheme.defaultInstance();
// }