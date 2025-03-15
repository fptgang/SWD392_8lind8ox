import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile/base/theme/theme.dart';

class CommonErrorWidget extends StatelessWidget {
  final String error;
  final VoidCallback? onRetry;
  final String? retryText;
  final TextStyle? errorTextStyle;
  final ButtonStyle? retryButtonStyle;

  const CommonErrorWidget({
    super.key,
    required this.error,
    this.onRetry,
    this.retryText,
    this.errorTextStyle,
    this.retryButtonStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Error: $error',
            style: errorTextStyle ??
                TextStyle(
                  color: getColorSkin().primaryRed600,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          onRetry != null
              ? ElevatedButton(
                  onPressed: onRetry,
                  style: retryButtonStyle ??
                      ElevatedButton.styleFrom(
                        backgroundColor: getColorSkin().primaryRed600,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                  child: Text(
                    retryText ?? AppLocalizations.of(context)?.retry ?? 'Retry',
                    style: TextStyle(
                      color: getColorSkin().white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
