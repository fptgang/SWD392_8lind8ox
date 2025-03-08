import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:html_unescape/html_unescape.dart';
import '../../../blocs/blindbox_detail/blindbox_detail_bloc.dart';
import '../../../blocs/blindbox_detail/blindbox_detail_event.dart';
import '../../../blocs/blindbox_detail/blindbox_detail_state.dart';
import '../../../ui/core/theme/theme.dart';
import 'quantity_selector.dart';
import 'type_selector.dart';

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
    
    // Create an HTML unescape instance to handle HTML entities
    final htmlUnescape = HtmlUnescape();
    
    // Process description - it could be HTML or plain text
    final String description = blindBox.description;
    final bool isHtmlContent = _isHtmlContent(description);
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            blindBox.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),

          // Price + Quantity
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

          // Description
          Text(
            appLocalizations.description,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          
          // Render description as HTML or plain text based on content
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
      return "\$${selectedSku.price!}";
    } else if (state.blindBox.skus.isNotEmpty && state.blindBox.skus.first.price != null) {
      return "\$${state.blindBox.skus.first.price!}";
    }
    return "\$0.00";
  }
} 