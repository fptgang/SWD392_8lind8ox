import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/base/theme/theme.dart';
import 'package:mobile/data/models/create_shipping_info_model.dart';
import 'package:mobile/data/models/shipping_info_model.dart';
import 'package:mobile/feature/shipping_address/bloc/shipping_info_bloc.dart';
import 'package:mobile/feature/shipping_address/bloc/shipping_info_event.dart';
import 'package:mobile/feature/shipping_address/widgets/form_field.dart';

class ShippingAddressFormScreen extends StatefulWidget {
  final ShippingInfoModel? address;

  const ShippingAddressFormScreen({Key? key, this.address}) : super(key: key);

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

  bool _isDefault = false;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.address != null;

    if (_isEditing) {
      _nameController.text = widget.address?.name ?? '';
      _phoneController.text = widget.address?.phoneNumber ?? '';
      _addressController.text = widget.address?.address ?? '';
      _wardController.text = widget.address?.ward ?? '';
      _districtController.text = widget.address?.district ?? '';
      _cityController.text = widget.address?.city ?? '';
      // _isDefault = widget.address?.isVisible ?? false;
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: getColorSkin().primaryRed650,
        title: Text(
          _isEditing ? 'Sửa Địa chỉ' : 'Địa chỉ mới',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
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
                _buildSectionTitle('Địa chỉ'),
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

                if (_isEditing)
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _showDeleteConfirmation(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: getColorSkin().primaryRed650,
                            side: BorderSide(color: getColorSkin().primaryRed650),
                            padding: EdgeInsets.symmetric(vertical: 15.h),
                          ),
                          child: const Text('Xóa địa chỉ'),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _saveAddress,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: getColorSkin().primaryRed650,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 15.h),
                          ),
                          child: const Text('HOÀN THÀNH'),
                        ),
                      ),
                    ],
                  )
                else
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveAddress,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: getColorSkin().primaryRed650,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 15.h),
                      ),
                      child: const Text('HOÀN THÀNH'),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
        color: getColorSkin().darkGrey,
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xóa địa chỉ'),
          content: const Text('Bạn có chắc muốn xóa địa chỉ này?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Hủy',
                style: TextStyle(color: getColorSkin().grey),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                _deleteAddress();
              },
              child: Text(
                'Xóa',
                style: TextStyle(color: getColorSkin().primaryRed650),
              ),
            ),
          ],
        );
      },
    );
  }

  void _saveAddress() {
    if (_formKey.currentState!.validate()) {
      final shippingInfo = CreateShippingInfoModel(
        name: _nameController.text,
        phoneNumber: _phoneController.text,
        address: _addressController.text,
        ward: _wardController.text,
        district: _districtController.text,
        city: _cityController.text,
      );

      if (_isEditing && widget.address != null) {
        context.read<ShippingInfoBloc>().add(
          UpdateShippingInfo(
            widget.address!.shippingInfoId!,
            shippingInfo,
          ),
        );
      } else {
        debugPrint('Creating new address');
        context.read<ShippingInfoBloc>().add(
          CreateShippingInfo(shippingInfo),
        );
      }

      Navigator.pop(context);
    }
  }

  void _deleteAddress() {
    if (_isEditing && widget.address != null) {
      context.read<ShippingInfoBloc>().add(
        DeleteShippingInfo(widget.address!.shippingInfoId!),
      );
      Navigator.pop(context);
    }
  }
}