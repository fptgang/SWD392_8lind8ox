import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:mobile/base/theme/theme.dart';
import 'package:mobile/feature/shipping/blocs/map/map_bloc.dart';
import 'package:mobile/feature/shipping/blocs/map/map_event.dart';
import 'package:mobile/feature/shipping/blocs/map/map_state.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
  MapboxMap? _mapboxMap;
  late MapBloc _mapBloc;
  PointAnnotationManager? _pointAnnotationManager;
  
  @override
  void initState() {
    super.initState();
    _mapBloc = widget.mapBloc;
    // Initialize Mapbox with the Goong token
    MapboxOptions.setAccessToken(dotenv.env['VITE_GOONG_TOKEN_KEY'] ?? '');
  }

  void _onMapCreated(MapboxMap mapboxMap) async {
    _mapboxMap = mapboxMap;
    
    // Set up the map style from Goong with API key
    final goongApiKey = dotenv.env['GOONG_API_KEY'] ?? '';
    await mapboxMap.style.setStyleURI(
      "https://tiles.goong.io/assets/goong_map_web.json?api_key=$goongApiKey"
    );
    
    // Create point annotation manager
    _pointAnnotationManager = await mapboxMap.annotations.createPointAnnotationManager();
  }

  void _updateMarkerAtLocation(double longitude, double latitude) async {
    if (_pointAnnotationManager == null) return;

    // Remove existing markers
    await _pointAnnotationManager!.deleteAll();
    
    // Create new marker
    await _pointAnnotationManager!.create(PointAnnotationOptions(
      geometry: Point.fromJson({
        "type": "Point",
        "coordinates": [longitude, latitude]
      }),
      iconSize: 1.5,
      iconImage: "pin",
    ));
  }

  void _handleMapTap(MapContentGestureContext context) {
    final coordinates = context.point.coordinates;
    if (coordinates != null && coordinates.length >= 2) {
      final longitude = coordinates[0];
      final latitude = coordinates[1];
      
      if (longitude != null && latitude != null) {
        _updateMarkerAtLocation(longitude.toDouble(), latitude.toDouble());
        
        // Update current location in the bloc
        _mapBloc.add(UpdateLocation(latitude.toDouble(), longitude.toDouble()));

        // Notify parent
        if (widget.onLocationSelected != null) {
          widget.onLocationSelected!(LatLng(latitude.toDouble(), longitude.toDouble()));
        }
      }
    }
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
          double defaultLongitude = 106.700760;
          double defaultLatitude = 10.776530;

          // Use selected place location if available
          double longitude = state.selectedPlace?.location.longitude ?? 
                           state.currentLocation?.longitude ?? 
                           defaultLongitude;
          double latitude = state.selectedPlace?.location.latitude ?? 
                          state.currentLocation?.latitude ?? 
                          defaultLatitude;

          // Update marker and camera position
          if (_mapboxMap != null) {
            _updateMarkerAtLocation(longitude, latitude);
            
            // Move camera to the new position
            _mapboxMap!.flyTo(
              CameraOptions(
                center: Point.fromJson({
                  "type": "Point",
                  "coordinates": [longitude, latitude]
                }),
                zoom: 15.0,
              ),
              MapAnimationOptions(duration: 500),
            );
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
                    key: const ValueKey("mapWidget"),
                    onMapCreated: _onMapCreated,
                    onTapListener: _handleMapTap,
                    cameraOptions: CameraOptions(
                      center: Point.fromJson({
                        "type": "Point",
                        "coordinates": [longitude, latitude]
                      }),
                      zoom: 15.0,
                    ),
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