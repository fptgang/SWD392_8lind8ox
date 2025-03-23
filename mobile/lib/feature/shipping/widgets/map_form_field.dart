import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:mobile/base/theme/theme.dart';
import 'package:mobile/feature/shipping/blocs/map/map_bloc.dart';
import 'package:mobile/feature/shipping/blocs/map/map_event.dart';
import 'package:mobile/feature/shipping/blocs/map/map_state.dart';

class MapFormField extends StatefulWidget {
  final String title;
  final double height;
  final Function(LatLng)? onLocationSelected;
  final MapBloc mapBloc;

  const MapFormField({
    Key? key,
    required this.title,
    required this.mapBloc,
    this.height = 250,
    this.onLocationSelected,
  }) : super(key: key);

  @override
  State<MapFormField> createState() => _MapFormFieldState();
}

class _MapFormFieldState extends State<MapFormField> {
  final MapController _mapController = MapController();
  LatLng? _markerPosition;
  late MapBloc _mapBloc;

  @override
  void initState() {
    super.initState();
    _mapBloc = widget.mapBloc;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _mapBloc,
      child: BlocBuilder<MapBloc, MapState>(
        buildWhen: (previous, current) =>
            previous.selectedPlace != current.selectedPlace ||
            previous.currentLocation != current.currentLocation,
        builder: (context, state) {
          // Default position (Ho Chi Minh City)
          final defaultPosition = LatLng(10.776530, 106.700760);

          // Use selected place location if available
          final position = state.selectedPlace != null
              ? LatLng(
                  state.selectedPlace!.location.latitude,
                  state.selectedPlace!.location.longitude,
                )
              : state.currentLocation != null
                  ? LatLng(
                      state.currentLocation!.latitude,
                      state.currentLocation!.longitude,
                    )
                  : defaultPosition;

          // Update marker position
          if (_markerPosition == null || _markerPosition != position) {
            _markerPosition = position;
            // Move the map to the new position
            Future.microtask(() {
              try {
                _mapController.move(position, 15.0);
              } catch (e) {
                // Ignore if the map controller is not ready yet
              }
            });

            // Notify parent about location selection
            if (widget.onLocationSelected != null) {
              widget.onLocationSelected!(position);
            }
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: getColorSkin().darkGrey,
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                height: widget.height.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: getColorSkin().lightGrey300),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: MapWidget(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: position,
                      initialZoom: 15.0,
                      interactionOptions: const InteractionOptions(
                        flags: InteractiveFlag.all,
                      ),
                      onTap: (tapPosition, latLng) {
                        // Update marker position
                        setState(() {
                          _markerPosition = latLng;
                        });

                        // Update current location in the bloc
                        _mapBloc.add(
                          UpdateLocation(
                            latLng.latitude,
                            latLng.longitude,
                          ),
                        );

                        // Notify parent
                        if (widget.onLocationSelected != null) {
                          widget.onLocationSelected!(latLng);
                        }
                      },
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.blindbox.app',
                      ),
                      MarkerLayer(
                        markers: [
                          if (_markerPosition != null)
                            Marker(
                              width: 40.0,
                              height: 40.0,
                              point: _markerPosition!,
                              child: const Icon(
                                Icons.location_pin,
                                color: Colors.red,
                                size: 40,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}