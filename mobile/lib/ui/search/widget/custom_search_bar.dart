import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/blocs/blindbox_list/blindbox_list_state.dart';
import 'package:mobile/blocs/search/search_bloc.dart';
import 'package:mobile/blocs/search/search_state.dart';
import 'package:mobile/ui/core/theme/theme.dart';

import '../../../blocs/search/search_event.dart';

class CustomSearchBar extends StatelessWidget {
  final String defaultText;

  const CustomSearchBar({
    super.key,
    required this.defaultText,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        final searchQuery = state is SearchQueryState ? state.query ?? '' : '';

        return KeyboardListener(
          focusNode: FocusNode(),
          onKeyEvent: (event) {
            if (event is KeyDownEvent &&
                event.logicalKey == LogicalKeyboardKey.enter &&
                searchQuery.trim().isNotEmpty) {
              context.read<SearchBloc>().add(SubmitSearch(searchQuery));
            }
          },
          child: TextFormField(
            style: TextStyle(
              fontSize: 14.sp,
              color: getColorSkin().black,
            ),
            decoration: InputDecoration(
              hintText: defaultText,
              hintStyle: TextStyle(
                color: getColorSkin().grey,
                fontSize: 14.sp,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: getColorSkin().grey,
                size: 20.r,
              ),
              suffixIcon: searchQuery.isNotEmpty
                  ? IconButton(
                icon: Icon(
                  Icons.close,
                  color: getColorSkin().grey,
                  size: 20.r,
                ),
                onPressed: () {
                  context.read<SearchBloc>().add(ClearSearch());
                },
              )
                  : null,
              filled: true,
              fillColor: getColorSkin().grey.withOpacity(0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: getColorSkin().primaryRed650,
                  width: 1,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 12.h,
              ),
            ),
            onChanged: (value) {
              context.read<SearchBloc>().add(SearchTextChanged(value));
            },
            onFieldSubmitted: (value) {
              if (value.trim().isNotEmpty) {
                context.read<SearchBloc>().add(SubmitSearch(value));
              }
            },
            // Add a key press listener to handle Enter key
            textInputAction: TextInputAction.search,
          ),
        );
      },
    );
  }
}