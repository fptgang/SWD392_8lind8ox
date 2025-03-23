import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/base/theme/theme.dart';
import 'package:mobile/data/models/location_model.dart';
import 'package:mobile/feature/shipping/blocs/map/map_bloc.dart';
import 'package:mobile/feature/shipping/blocs/map/map_event.dart';
import 'package:mobile/feature/shipping/blocs/map/map_state.dart';

class AddressSearchField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final Function(String)? onPlaceSelected;
  final MapBloc mapBloc;

  const AddressSearchField({
    Key? key,
    required this.controller,
    required this.mapBloc,
    this.labelText = 'Tìm kiếm địa chỉ',
    this.hintText = 'Nhập địa chỉ để tìm kiếm',
    this.onPlaceSelected,
  }) : super(key: key);

  @override
  State<AddressSearchField> createState() => _AddressSearchFieldState();
}

class _AddressSearchFieldState extends State<AddressSearchField> {
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  bool _showOverlay = false;
  late MapBloc _mapBloc;

  @override
  void initState() {
    super.initState();
    _mapBloc = widget.mapBloc;
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _removeOverlay();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      _showOverlay = true;
      _showPredictionsOverlay();
    } else {
      _removeOverlay();
      _showOverlay = false;
    }
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _showPredictionsOverlay() {
    if (_overlayEntry != null) {
      _removeOverlay();
    }

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height),
          child: Material(
            elevation: 4,
            child: BlocProvider.value(
              value: _mapBloc,
              child: _buildPredictionsList(),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  Widget _buildPredictionsList() {
    return BlocBuilder<MapBloc, MapState>(
      buildWhen: (previous, current) =>
          previous.predictions != current.predictions ||
          previous.status != current.status,
      builder: (context, state) {
        if (state.status == MapStatus.loading) {
          return Container(
            padding: EdgeInsets.all(16.w),
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          );
        }
        
        if (state.predictions.isEmpty) {
          return Container(
            padding: EdgeInsets.all(16.w),
            child: Text(
              'Không tìm thấy kết quả phù hợp',
              style: TextStyle(
                fontSize: 14.sp,
                color: getColorSkin().grey,
              ),
            ),
          );
        }

        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: 200.h,
          ),
          child: ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: state.predictions.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: getColorSkin().lightGrey300,
            ),
            itemBuilder: (context, index) {
              final prediction = state.predictions[index];
              return ListTile(
                title: Text(
                  prediction.structuredFormatting.mainText,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  prediction.structuredFormatting.secondaryText,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: getColorSkin().grey,
                  ),
                ),
                onTap: () {
                  _onPredictionTap(prediction);
                },
              );
            },
          ),
        );
      },
    );
  }

  void _onPredictionTap(Prediction prediction) {
    // Update the text field
    widget.controller.text = prediction.description;

    // Notify parent
    if (widget.onPlaceSelected != null) {
      widget.onPlaceSelected!(prediction.placeId);
    }

    // Hide overlay and unfocus
    _removeOverlay();
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _mapBloc,
      child: CompositedTransformTarget(
        link: _layerLink,
        child: BlocBuilder<MapBloc, MapState>(
          buildWhen: (previous, current) =>
              previous.searchTerm != current.searchTerm ||
              previous.status != current.status,
          builder: (context, state) {
            return TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              decoration: InputDecoration(
                labelText: widget.labelText,
                hintText: widget.hintText,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: state.status == MapStatus.loading
                    ? Container(
                        width: 24,
                        height: 24,
                        padding: const EdgeInsets.all(8),
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      )
                    : widget.controller.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              widget.controller.clear();
                              _mapBloc.add(SearchPlaces(''));
                            },
                          )
                        : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: getColorSkin().lightGrey300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: getColorSkin().primaryRed650),
                ),
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  _mapBloc.add(SearchPlaces(value));
                }
              },
            );
          },
        ),
      ),
    );
  }
}