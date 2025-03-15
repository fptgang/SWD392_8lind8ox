import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile/base/theme/theme.dart';

Widget buildEmptyIndicator(BuildContext context) {
  return Center(
    child: Text(AppLocalizations.of(context)?.empty ?? 'No items found',
        style: TextStyle(color: getColorSkin().grey, fontSize: 14)),
  );
}
