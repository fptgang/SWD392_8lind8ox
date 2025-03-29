import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/app/di/injection.dart';
import 'package:mobile/base/theme/theme.dart';
import 'package:mobile/base/theme/theme.dart';
import 'package:mobile/data/models/shipping_info_model.dart';
import 'package:mobile/data/repositories/shipping_info_repository.dart';
import 'package:mobile/feature/shipping/blocs/shipping_address/shipping_info_bloc.dart';
import 'package:mobile/feature/shipping/blocs/shipping_address/shipping_info_event.dart';
import 'package:mobile/feature/shipping/blocs/shipping_address/shipping_info_state.dart';

class AddressSection extends StatefulWidget {
  const AddressSection({
    super.key,
    this.selectedAddressId,
    required this.onSelectAddress,
  });

  final int? selectedAddressId;
  final Function(int) onSelectAddress;

  @override
  State<AddressSection> createState() => _AddressSectionState();
}

class _AddressSectionState extends State<AddressSection> {
  late final ShippingInfoBloc _shippingInfoBloc;
  bool _isLoading = true;
  List<ShippingInfoModel> _addresses = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    // Create a new ShippingInfoBloc instance with the repository from GetIt
    _shippingInfoBloc = ShippingInfoBloc(getIt<ShippingInfoRepository>());

    // Load addresses when the widget initializes
    _loadAddresses();
  }

  @override
  void dispose() {
    // Clean up the bloc when widget is disposed
    _shippingInfoBloc.close();
    super.dispose();
  }

  Future<void> _loadAddresses() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    _shippingInfoBloc.add(GetShippingInfos());
  }

  @override
  Widget build(BuildContext context) {
    final colorSkin = getColorSkin();

    return BlocListener<ShippingInfoBloc, ShippingInfoState>(
      bloc: _shippingInfoBloc,
      listener: (context, state) {
        if (state is ShippingInfoDataState) {
          setState(() {
            _addresses = state.shippingInfos;
            _isLoading = false;
          });
        } else if (state is ShippingInfoLoadingState && state.error != null) {
          setState(() {
            _error = state.error;
            _isLoading = false;
          });
        }
      },
      child: Card(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: colorSkin.lightGrey300, width: 1),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [
                colorSkin.white,
                colorSkin.lightGrey100,
              ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: colorSkin.primaryRed650,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Shipping Address',
                        style: TextStyle(
                          fontSize: 18,
                          color: colorSkin.primaryRed800,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  TextButton.icon(
                    onPressed: () => _navigateToAddressScreen(context),
                    icon: Icon(Icons.add, color: colorSkin.primaryRed650),
                    label: Text(
                      'Add New',
                      style: TextStyle(
                        color: colorSkin.primaryRed650,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: colorSkin.primaryRed650.withOpacity(0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    final colorSkin = getColorSkin();

    if (_isLoading) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: CircularProgressIndicator(color: colorSkin.primaryRed650),
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorSkin.warningRed.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colorSkin.warningRed.withOpacity(0.3)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: colorSkin.warningRed,
              ),
              const SizedBox(height: 16),
              Text(
                'Error loading shipping addresses:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: colorSkin.warningRed,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$_error',
                textAlign: TextAlign.center,
                style: TextStyle(color: colorSkin.warningRed),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _loadAddresses,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorSkin.warningRed.withOpacity(0.1),
                  foregroundColor: colorSkin.warningRed,
                  elevation: 0,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_addresses.isEmpty) {
      return _buildEmptyAddresses(context);
    }

    return Column(
      children: _addresses
          .map((address) => _buildAddressItem(context, address))
          .toList(),
    );
  }

  Widget _buildEmptyAddresses(BuildContext context) {
    final colorSkin = getColorSkin();

    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: colorSkin.lightGrey100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorSkin.lightGrey300),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off,
              size: 56,
              color: colorSkin.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'No shipping addresses found',
              style: TextStyle(
                fontSize: 18,
                color: colorSkin.darkGrey,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please add a shipping address to continue',
              textAlign: TextAlign.center,
              style: TextStyle(color: colorSkin.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _navigateToAddressScreen(context),
              icon: const Icon(Icons.add),
              label: const Text('Add New Address'),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorSkin.primaryRed650,
                foregroundColor: colorSkin.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressItem(BuildContext context, ShippingInfoModel address) {
    final colorSkin = getColorSkin();
    final isSelected = widget.selectedAddressId == address.shippingInfoId;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          if (address.shippingInfoId != null) {
            widget.onSelectAddress(address.shippingInfoId!);
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  isSelected ? colorSkin.primaryRed650 : colorSkin.lightGrey300,
              width: isSelected ? 2 : 1,
            ),
            color: isSelected
                ? colorSkin.primaryRed650.withOpacity(0.08)
                : colorSkin.white,
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: colorSkin.shadowLight,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    )
                  ]
                : null,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 4),
                child: isSelected
                    ? Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colorSkin.primaryRed650,
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 16,
                          color: Colors.white,
                        ),
                      )
                    : Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: colorSkin.grey),
                        ),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            address.name ?? 'No Name',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: isSelected
                                  ? colorSkin.primaryRed800
                                  : colorSkin.darkGrey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.phone,
                          size: 14,
                          color: colorSkin.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          address.phoneNumber ?? 'No Phone',
                          style: TextStyle(
                            color: colorSkin.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 14,
                          color: colorSkin.grey,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            [
                              address.address,
                              address.ward,
                              address.district,
                              address.city,
                            ]
                                .where((s) => s != null && s.isNotEmpty)
                                .join(', '),
                            style: TextStyle(
                              color: colorSkin.grey,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.edit_outlined,
                  size: 20,
                  color: isSelected ? colorSkin.primaryRed650 : colorSkin.grey,
                ),
                onPressed: () => _navigateToEditAddress(context, address),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToAddressScreen(BuildContext context) {
    context.push('/shipping-address').then((_) {
      // Refresh addresses after returning from the shipping address screen
      _loadAddresses();
    });
  }

  void _navigateToEditAddress(BuildContext context, ShippingInfoModel address) {
    // Navigate to the edit address screen with the address as extra data
    context.push('/shipping-address-form', extra: address).then((_) {
      // Refresh addresses after returning from the edit screen
      _loadAddresses();
    });
  }
}
