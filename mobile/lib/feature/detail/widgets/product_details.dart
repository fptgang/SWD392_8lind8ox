import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:mobile/base/theme/theme.dart';
import 'package:mobile/feature/detail/widgets/quantity_selector.dart';
import 'package:mobile/feature/detail/widgets/type_selector.dart';

import '../blocs/blindbox_detail_state.dart';

class ProductDetails extends StatelessWidget {
  final BlindBoxDataState state;

  const ProductDetails({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final blindBox = state.blindBox;
    final quantity = state.quantity;
    final appLocalizations = AppLocalizations.of(context)!;

    final htmlUnescape = HtmlUnescape();

    final String description = blindBox.description ?? '';
    final bool isHtmlContent = _isHtmlContent(description);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            blindBox.name ?? 'Unnamed Product',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Text(
                _formatPrice(state),
                style: const TextStyle(fontSize: 16),
              ),
              const Spacer(),
              QuantitySelector(quantity: quantity),
            ],
          ),
          SizedBox(height: 16.h),
          TypeSelector(state: state),
          SizedBox(height: 16.h),
          Text(
            appLocalizations.description,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          if (isHtmlContent)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Html(
                data: description,
                shrinkWrap: true,
                style: {
                  "body": Style(
                    margin: Margins.zero,
                    padding: HtmlPaddings.zero,
                    color: getColorSkin().grey,
                    fontSize: FontSize(14.0),
                  ),
                  "p": Style(
                    margin: Margins.only(bottom: 8),
                    color: getColorSkin().grey,
                  ),
                  "div": Style(
                    margin: Margins.only(bottom: 8),
                    color: getColorSkin().grey,
                  ),
                  "li": Style(
                    color: getColorSkin().grey,
                  ),
                  "span": Style(
                    color: getColorSkin().grey,
                  ),
                  "a": Style(
                    color: getColorSkin().primaryRed650,
                    textDecoration: TextDecoration.underline,
                  ),
                  // Add more style customizations as needed
                },
              ),
            )
          else
            SizedBox(
              width: double.infinity,
              child: Text(
                htmlUnescape.convert(description),
                style: TextStyle(color: getColorSkin().grey),
              ),
            ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  // Helper method to check if content is HTML
  bool _isHtmlContent(String text) {
    if (text.isEmpty) return false;

    // Simple check for common HTML tags
    return text.contains('<') &&
        text.contains('>') &&
        (text.contains('<p>') ||
            text.contains('<div>') ||
            text.contains('<br') ||
            text.contains('<span') ||
            text.contains('<h') ||
            text.contains('<ul') ||
            text.contains('<li'));
  }

  String _formatPrice(BlindBoxDataState state) {
    final selectedSku = state.sku;
    if (selectedSku != null && selectedSku.price != null) {
      return "\$${selectedSku.price!.toStringAsFixed(2)}";
    } else if (state.blindBox.skus != null &&
        state.blindBox.skus!.isNotEmpty &&
        state.blindBox.skus!.first.price != null) {
      return "\$${state.blindBox.skus!.first.price!.toStringAsFixed(2)}";
    }
    return "\$0.00";
  }
}
