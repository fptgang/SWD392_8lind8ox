import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobile/app/di/injection.dart';
import 'package:mobile/app/main.dart';
import 'package:mobile/base/theme/theme.dart';
import 'package:mobile/data/models/create_shipping_info_model.dart';
import 'package:mobile/data/models/location_model.dart';
import 'package:mobile/data/models/shipping_info_model.dart';
import 'package:mobile/data/repositories/map_repository.dart';
import 'package:mobile/feature/shipping/blocs/map/map_bloc.dart';
import 'package:mobile/feature/shipping/blocs/map/map_event.dart';
import 'package:mobile/feature/shipping/blocs/map/map_state.dart';
import 'package:mobile/feature/shipping/blocs/shipping_address/shipping_info_bloc.dart';
import 'package:mobile/feature/shipping/blocs/shipping_address/shipping_info_event.dart';
import 'package:mobile/feature/shipping/widgets/address_search_field.dart';
import 'package:mobile/feature/shipping/widgets/form_field.dart';
import 'package:mobile/feature/shipping/widgets/map_form_field.dart';

class ShippingAddressFormScreen extends StatefulWidget {
  final ShippingInfoModel? address;

  const ShippingAddressFormScreen({super.key, this.address});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const ShippingAddressFormScreen());
  }

  @override
  State<ShippingAddressFormScreen> createState() => _ShippingAddressFormScreenState();
}

class _ShippingAddressFormScreenState extends State<ShippingAddressFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _wardController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  bool _isDefault = false;
  bool _isEditing = false;
  LatLng? _selectedLocation;
  
  // Store reference to the MapBloc
  late MapBloc _mapBloc;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.address != null;
    
    // Initialize the MapBloc here
    _mapBloc = MapBloc(mapRepository: getIt<MapRepository>());
    
    if (_isEditing) {
      _nameController.text = widget.address?.name ?? '';
      _phoneController.text = widget.address?.phoneNumber ?? '';
      _addressController.text = widget.address?.address ?? '';
      _wardController.text = widget.address?.ward ?? '';
      _districtController.text = widget.address?.district ?? '';
      _cityController.text = widget.address?.city ?? '';
      _isDefault = widget.address?.isVisible ?? false;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _wardController.dispose();
    _districtController.dispose();
    _cityController.dispose();
    _searchController.dispose();
    _mapBloc.close(); // Close the bloc when the screen is disposed
    super.dispose();
  }

  void _handlePlaceSelected(PlaceDetail place) {
    final addressParts = place.formattedAddress.split(', ');
    
    if (addressParts.length >= 4) {
      _addressController.text = addressParts[0];
      _wardController.text = addressParts[1];
      _districtController.text = addressParts[2];
      
      final cityPart = addressParts[3].split(' ');
      if (cityPart.isNotEmpty) {
        _cityController.text = cityPart[0];
      }
    } else {
      _addressController.text = place.formattedAddress;
    }
  }

  void _handleLocationSelected(LatLng location) {
    _selectedLocation = location;
    
    // Update the location in the MapBloc using our stored reference
    _mapBloc.add(
      UpdateLocation(location.latitude, location.longitude),
    );
    
    // Perform reverse geocoding to get address details
    final mapRepository = getIt<MapRepository>();
    mapRepository.reverseGeocode(
      location.latitude, 
      location.longitude
    ).then((address) {

      if (address != null) {
        setState(() {
          _addressController.text = address.streetAddress ?? '';
          _wardController.text = address.ward ?? '';
          _districtController.text = address.district ?? '';
          _cityController.text = address.city ?? '';
        });
      }
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching address details: $error'),
          backgroundColor: Colors.red,
        ),
      );
    });
  }

  void _saveAddress() {
    if (_formKey.currentState!.validate()) {
      final shippingInfoBloc = context.read<ShippingInfoBloc>();
      
      if (_isEditing && widget.address != null) {
        // Create a CreateShippingInfoModel from the form values
        final updateModel = CreateShippingInfoModel(
          name: _nameController.text,
          phoneNumber: _phoneController.text,
          address: _addressController.text,
          ward: _wardController.text,
          district: _districtController.text,
          city: _cityController.text,
        );
        
        // Update existing address
        shippingInfoBloc.add(UpdateShippingInfo(
          widget.address!.shippingInfoId!, 
          updateModel
        ));
        
        // Set as default if needed
        if (_isDefault && widget.address!.isVisible != true) {
          shippingInfoBloc.add(SetDefaultShippingInfo(widget.address!.shippingInfoId!));
        }
      } else {
        // Create new address
        final createModel = CreateShippingInfoModel(
          name: _nameController.text,
          phoneNumber: _phoneController.text,
          address: _addressController.text,
          ward: _wardController.text,
          district: _districtController.text,
          city: _cityController.text,
        );
        
        shippingInfoBloc.add(CreateShippingInfo(createModel));
      }
      
      AppRouter.router.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          _isEditing ? 'Cập nhật địa chỉ' : 'Thêm địa chỉ mới',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => AppRouter.router.pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<MapBloc, MapState>(
                  buildWhen: (previous, current) =>
                    previous.selectedPlace != current.selectedPlace,
                  builder: (context, state) {
                    if (state.selectedPlace != null) {
                      _handlePlaceSelected(state.selectedPlace!);
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tìm kiếm địa chỉ',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: getColorSkin().darkGrey,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        BlocProvider(
                          create: (_) => _mapBloc,
                          child: AddressSearchField(
                            controller: _searchController,
                            mapBloc: _mapBloc,
                            labelText: 'Tìm kiếm',
                            hintText: 'Nhập địa chỉ để tìm kiếm',
                            onPlaceSelected: (placeId) {
                              _mapBloc.add(
                                SelectPlace(placeId),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 16.h),
                      ],
                    );
                  },
                ),

                // Map Form Field
                MapFormField(
                  key: const Key('map_form_field'),
                  title: 'Chọn vị trí trên bản đồ',
                  mapBloc: _mapBloc,
                  height: 200,
                  onLocationSelected: (latLng) {
                    _handleLocationSelected(latLng);
                  },
                ),
                SizedBox(height: 16.h),

                // Full Name
                FormTextField(
                  controller: _nameController,
                  labelText: 'Họ và tên',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập họ và tên';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),

                // Phone Number
                FormTextField(
                  controller: _phoneController,
                  labelText: 'Số điện thoại',
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập số điện thoại';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),

                // City
                FormTextField(
                  controller: _cityController,
                  labelText: 'Tỉnh/Thành phố',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập Tỉnh/Thành phố';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),

                // District
                FormTextField(
                  controller: _districtController,
                  labelText: 'Quận/Huyện',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập Quận/Huyện';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),

                // Ward
                FormTextField(
                  controller: _wardController,
                  labelText: 'Phường/Xã',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập Phường/Xã';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),

                // Street Address
                FormTextField(
                  controller: _addressController,
                  labelText: 'Tên đường, Toà nhà, Số nhà.',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập địa chỉ chi tiết';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24.h),

                // Default Address Switch
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Đặt làm địa chỉ mặc định',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Switch(
                      value: _isDefault,
                      onChanged: (value) {
                        setState(() {
                          _isDefault = value;
                        });
                      },
                      activeColor: getColorSkin().primaryRed650,
                    ),
                  ],
                ),
                SizedBox(height: 24.h),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveAddress,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: getColorSkin().primaryRed650,
                      padding: EdgeInsets.symmetric(vertical: 15.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      _isEditing ? 'CẬP NHẬT' : 'LƯU ĐỊA CHỈ',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}